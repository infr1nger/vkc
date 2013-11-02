# coding: utf-8
require "rubygems"
require "nokogiri"


class ParserController < ApplicationController
  def index
    doc = Nokogiri::HTML(open('http://www.hopesandfears.com/hopesandfears/experience/case/123267-hirosi-mikitani-marketpleys-3-0'))
    @ant = doc.css("div[class=article-text]")
  end
end
  

