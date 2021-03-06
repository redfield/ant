require "ant/version"
require "ant/null_tag"
require "ant/tag"
require "ant/text_node"
require "ant/node"
require "ant/parser"

module Ant

  extend self

  #
  # Преобразование bbcode-ов в html
  #
  # Ant.to_html(%{[p]my 'string!\'' [i color="#f00"]red text[/i]})
  # Ant.to_html(%{[p]my 'string!\'' var i = [1,2,3]; [i color="#f00"]red text[/i]})
  #
  def to_html(str, options = {
    quotes:     true,
    minuses:    true,
    new_lines:  true
  })

    ::Ant::Parser.new(str.to_s, options).to_html

  end # to_html

  #
  # Задание параетров блоком
  #
  # Ant.config do
  #
  #  tag :strong
  #  tag :li
  #
  # end
  #
  #
  def config(&block)
    instance_eval(&block)
  end # config

  #
  # Объявление тега
  #
  def tag(name, singular: false, aliases: [], slaves: nil, &block)

    def_tag = ::Ant::Tag.new(name,
      singular: singular,
      slaves:   slaves,
      aliases:  aliases,
      &block
    )

    (aliases << name).each { |al|
      tags_map[al.to_sym] = def_tag
    }

    self

  end # tag

  #
  # Взятие тега по имени (используется в коде редактора)
  #
  def get(name)

    return if name.nil?
    tags_map[name.to_sym]

  end # get

  #
  # Удаление тега из объявления
  #
  def remove(name)

    tags_map[name.to_sym] = nil unless name.nil?
    self

  end # remove

  #
  # Удаление всех тегов
  #
  def clean(name)

    @tags_map = {}
    self

  end # clean

  #
  # Алиасы
  #
  alias :del    :remove
  alias :add    :tag
  alias :reset  :clean

  private

  #
  # Список тегов
  #
  def tags_map
    @tags_map ||= {}
  end # tags_map

end # Ant

require "ant/default"

# Если у нас rails -- интегрируемся
require 'ant/engine' if defined?(::Rails)
