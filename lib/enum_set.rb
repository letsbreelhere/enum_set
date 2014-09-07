require "enum_set/version"

module EnumSet
  EnumError = Class.new(NameError)

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def enum_set(enums)
      enums.each do |column, names|
        if !names.is_a?(Hash)
          names = Hash[
            names.each_with_index.map do |name, i|
              [name, 1 << i]
            end
          ]
        end

        names_with_bits = names.symbolize_keys

        define_method :"#{column}_bitfield" do
          self[column] || 0
        end

        names_with_bits.each do |name, bit|
          define_method :"#{name}?" do
            (bit & send("#{column}_bitfield")) != 0
          end

          scope :"#{name}", -> {
            where("#{column} & ? <> 0", bit)
          }
        end

        define_method :"#{column}=" do |values|
          case values
          when Array
            values.each do |val|
              raise EnumError.new("Unrecognized value for #{column}: #{val.inspect}") unless names.include?(val)
            end

            current_value = send("#{column}_bitfield")

            new_value = values.reduce(current_value) do |acc, val|
              acc | names_with_bits[val.to_sym]
            end
          when Fixnum
            new_value = values
          end

          self[column] = new_value
          send(column)
        end

        define_method column do
          names_with_bits.keys.select { |name| send(:"#{name}?") }
        end
      end
    end
  end
end
