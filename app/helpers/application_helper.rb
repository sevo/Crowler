module ApplicationHelper
  
  def link_to_add_fields(name, f, association, relative = true)
    new_object = f.object.class.reflect_on_association(association).klass.new  
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(association.to_s.singularize + "_fields", :f => builder)  
    end

    if relative
      link_to(name, "#", :class => "add_fields relative", :id => association)+
      (content_tag :div, :class => "hidden remove-before-send display-none" do
        raw fields
      end)
    else
      (content_tag :script do
        raw "fields[\"#{association}\"] = \"#{escape_javascript(fields)}\";"
      end)+
      link_to(name, "#", :class => "add_fields", :id => association)
    end
  end 


	def bool_to_human(value)
		I18n.t(value == true ? "yes" : "no")
  end

  def bool_to_human_with_empty(value)
    if value.nil?
      ""
    else
      I18n.t(value == true ? "yes" : "no")
    end
  end

  def map_link(value)
		if value.length > 0
			link_to I18n.t(:map), value, :target => "_blank"
		end
	end

	def admin_table_header_cell(search_form, f, translation_sub_scope, column)
    if column == ""
      return content_tag :td, ""
    end
    name = (column.is_a? Array) ? column.first : column
		order_name = input_name = translate_name = name

		options = {}
		if column.respond_to?(:last) && column.length > 1
			options = column.last
		end
		options.reverse_merge! :input => :text_field, :order_name => order_name, :input_name => input_name.to_s + "_contains", :translate_name => translate_name, :input_args => [], :label_wrapper_classes => []

    if options[:input] == :text_field
    end
    if options[:input] == :collection_select
    end


		[:order_name,:input_name,:translate_name].each do |index|
			if (options[index].to_s[0,1] == "_")
				options[index] = (name.to_s + options[index].to_s).to_sym
			end
    end

    label_wrapper_classes = ["label"] + options[:label_wrapper_classes]

    td_options = {}
    td_options = options[:td_options] if options[:td_options]
    

		string = ""
		string+= content_tag :td, td_options do
			(content_tag :div, :class => label_wrapper_classes.join(" ") do
				sort_link search_form, options[:order_name].to_sym, I18n.t(options[:translate_name].to_s, :scope => "simple_form.labels.#{translation_sub_scope}")
			end) +
			(content_tag :div, :class => "inputs" do
        if (options[:input] == :text_field)
          options[:input_args] << {:class => "string", :size => nil}
          content_tag :div, f.send(options[:input], *([options[:input_name].to_sym] + options[:input_args])), :class => "input-text-container"
        elsif (options[:input] == :collection_select)
          options[:input_args] << {:class => "custom"}
          content_tag :div, f.send(options[:input], *([options[:input_name].to_sym] + options[:input_args])), :class => "select-box"
        elsif (options[:input] == :skip)
          "&nbsp;".html_safe
        else
          f.send(options[:input], *([options[:input_name].to_sym] + options[:input_args]))
        end
      end)
		end
	  raw string
	end

	def admin_table_header(search_form, f, translation_sub_scope, columns)
		string = ""
	  columns.each do |column|
		  string+= admin_table_header_cell(search_form, f, translation_sub_scope, column)
	  end
	  raw string
	end

  ##quarry-material partial
    
  # get default selected (root of child) value if child exist otherwise blank 	
	def get_id_of_root_for_child(child)
	  child.nil? ? "" : Material.find_by_id(child.to_i).root.id    
	end
	
	#get all siblings of one child for options in selectbox if child exist otherwise empty collection
	def get_siblings_for_material(child)
	  child.nil? ? [] : Material.find_by_id(child.to_i).siblings
  end
	
	#pricelist item partial
	def get_full_name_materials_for_quarry(quarry)
    quarry.nil? ? [] : Quarry.find_by_id(quarry.to_i).materials.map{ |m| [m.root.name.to_s+" - "+ m.name.to_s,m.id]}
  end
	
	##dealers order for quarry()
	def get_quarry_for_dealer(dealer)
	  dealer.nil? ? [] : Dealer.find_by_id(dealer.to_i).quarries
	end
	
	##vrat vsechny root materialy pro specifickou dealer_order a v je uvedeno quarry co nabizi?
  def get_root_materials_for_order_item(dealer_order_id)
    dealer_order_id.nil? ? [] : DealerOrder.find_by_id(dealer_order_id.to_i).quarry.materials.map{|m| [m.root.name.to_s,m.root.id.to_s]}.uniq!
  end

  def mark_select(list_item_name, classes = [])
    if @selected.include?(list_item_name)
      classes << "selected"
    end
    if classes.blank?
      ""
    else
      " class='#{classes.join(" ")}'"
    end
  end


  def have_transport_orders?(building_id, quarry_id, material_id)
    @transport_order_items.key?(building_id) && @transport_order_items[building_id].key?(quarry_id) && @transport_order_items[building_id][quarry_id].key?(material_id)
  end

  def get_transport_orders(building_id, quarry_id, material_id)
    @transport_order_items[building_id][quarry_id][material_id]
  end

  def get_balance_flag(balance)
    if (1..100).include?(balance)
      :is_close
    elsif balance < 1.0
      :is_out
    else
      :normal
    end
  end

  def get_balance_class(balance, flag=nil)
    flag ? flag.to_s : get_balance_flag(balance).to_s
  end

  def color_balance(balance, flag=nil)
    content_tag :span, number_with_precision(balance), :class => get_balance_class(balance, flag)
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
