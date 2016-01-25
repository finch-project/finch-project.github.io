require 'csv'

def get_courses
  courses = []
  CSV.foreach('contents.csv') do |row|
    course = {}
    course[:title] = row[3]
    course[:category] = row[1]
    course[:code] = row[2]
    course[:description_ready] = false
    if row[0] == 'Oui'
      course[:description_ready] = true
      course[:description] = row[4]
      course[:objectives] = row[5]
      course[:audience] = row[6]
    end

    courses.push course
  end

  courses.delete_at(0); # remove header row
  courses
end

def create_post(course)
  header = "---
layout: course
title: #{course[:title]}
permalink: #{course[:code]}
description_ready: #{course[:description_ready]}
categories:
- #{course[:category]}
---
"

  description = course[:description] || "Plus d'information à venir..."
  objectives = course[:objectives] || "Plus d'information à venir..."
  audience = course[:audience] || "Plus d'information à venir..."

  content = ""
  content += "## Description\n#{description}\n\n"
  content += "## Objectifs\n#{objectives}\n\n"
  content += "## Public cible\n#{audience}\n\n"

  header + content
end

def create_post_file(course)
  f = File.new("../_posts/2099-12-31-#{course[:code]}.md", 'w')
  f.puts(create_post(course))
  f.close
end

courses = get_courses
courses.each { |course| create_post_file(course) }
