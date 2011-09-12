module ApplicationHelper

	def admin_table_header(search_form, f, translation_sub_scope, columns)
		string = ""
	  columns.each do |column|
		  string+= admin_table_header_cell(search_form, f, translation_sub_scope, column)
	  end
	  raw string
	end

  private

  def admin_table_header_cell(search_form, f, translation_sub_scope, column)
    if column == ""
      return content_tag :td, ""
    end

    options = set_options(column)

    label_wrapper_classes = ["label"] + options[:label_wrapper_classes]
    label_wrapper_classes_string = label_wrapper_classes.join(" ")

    sort_link = content_tag :div, :class => label_wrapper_classes_string do
				sort_link search_form, options[:order_name].to_sym, I18n.t(options[:translate_name].to_s, :scope => "simple_form.labels.#{translation_sub_scope}")
      end

    input_div = content_tag :div, :class => "inputs" do
       case options[:input]
         when :text_field
           options[:input_args] << {:class => "string", :size => nil}
           content_tag :div, f.send(options[:input], *([options[:input_name].to_sym] + options[:input_args])), :class => "input-text-container"
         when :collection_select
           options[:input_args] << {:class => "custom"}
           content_tag :div, f.send(options[:input], *([options[:input_name].to_sym] + options[:input_args])), :class => "select-box"
         when :skip
           "&nbsp;".html_safe
         else
           f.send(options[:input], *([options[:input_name].to_sym] + options[:input_args]))
       end
      end

		header_string = content_tag :td, options[:td_options] do
        sort_link +
        input_div
      end

	  raw header_string
	end

  def set_options(column)
    name = (column.is_a? Array) ? column.first : column
    order_name = input_name = translate_name = name

    if column.respond_to?(:last) && column.length > 1
      options = column.last
    else
      options = {}
    end

    options.reverse_merge! :input => :text_field, :order_name => order_name, :input_name => input_name.to_s + "_contains", :translate_name => translate_name, :input_args => [], :label_wrapper_classes => []

    [:order_name, :input_name, :translate_name].each do |index|
      if (options[index].to_s.start_with? "_")
        options[index] = (name.to_s + options[index].to_s).to_sym
      end
    end

    options[:td_options] ||= {}
    options
  end
end
