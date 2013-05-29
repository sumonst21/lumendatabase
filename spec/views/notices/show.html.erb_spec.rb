require 'spec_helper'

describe 'notices/show.html.erb' do
  it "displays a metadata from a notice" do
    notice = build(:notice, :with_body)
    assign(:notice, notice)

    render

    expect(rendered).to include notice.title
    expect(rendered).to include notice.body
  end

  it "displays the notices file" do
    notice = create(:notice_with_notice_file, content: "File content")
    assign(:notice, notice)

    render

    expect(rendered).to include("File content")
  end

  it "displays a notice with tags" do
    notice = create(:notice, :with_tags)
    assign(:notice, notice)

    render

    within('#tags') do
      expect(page).to have_content("a_tag")
    end
  end

  it "displays a notice with entities" do
    notice = create(:notice_with_entities)
    assign(:notice, notice)

    render

    within('#entities') do
      notice.entities.each do |entity|
        expect(page).to have_content(entity.name)
      end
    end
  end

  it "displays a notice with relevant questions" do
    notice = create(:notice, :with_questions, questions: [
      q1 = create(:relevant_question, question: "Q 1", answer: "A 1"),
      q2 = create(:relevant_question, question: "Q 2", answer: "A 2")
    ])
    assign(:notice, notice)

    render

    within('#relevant-questions') do
      within("#relevant_question_#{q1.id}") do
        expect(page).to have_content("Q 1")
        expect(page).to have_content("A 1")
      end

      within("#relevant_question_#{q2.id}") do
        expect(page).to have_content("Q 2")
        expect(page).to have_content("A 2")
      end
    end
  end
end
