require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ExamPapersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # ExamPaper. As you add validations to ExamPaper, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ExamPapersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all exam_papers as @exam_papers" do
      exam_paper = ExamPaper.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:exam_papers)).to eq([exam_paper])
    end
  end

  describe "GET #show" do
    it "assigns the requested exam_paper as @exam_paper" do
      exam_paper = ExamPaper.create! valid_attributes
      get :show, {:id => exam_paper.to_param}, valid_session
      expect(assigns(:exam_paper)).to eq(exam_paper)
    end
  end

  describe "GET #new" do
    it "assigns a new exam_paper as @exam_paper" do
      get :new, {}, valid_session
      expect(assigns(:exam_paper)).to be_a_new(ExamPaper)
    end
  end

  describe "GET #edit" do
    it "assigns the requested exam_paper as @exam_paper" do
      exam_paper = ExamPaper.create! valid_attributes
      get :edit, {:id => exam_paper.to_param}, valid_session
      expect(assigns(:exam_paper)).to eq(exam_paper)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new ExamPaper" do
        expect {
          post :create, {:exam_paper => valid_attributes}, valid_session
        }.to change(ExamPaper, :count).by(1)
      end

      it "assigns a newly created exam_paper as @exam_paper" do
        post :create, {:exam_paper => valid_attributes}, valid_session
        expect(assigns(:exam_paper)).to be_a(ExamPaper)
        expect(assigns(:exam_paper)).to be_persisted
      end

      it "redirects to the created exam_paper" do
        post :create, {:exam_paper => valid_attributes}, valid_session
        expect(response).to redirect_to(ExamPaper.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved exam_paper as @exam_paper" do
        post :create, {:exam_paper => invalid_attributes}, valid_session
        expect(assigns(:exam_paper)).to be_a_new(ExamPaper)
      end

      it "re-renders the 'new' template" do
        post :create, {:exam_paper => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested exam_paper" do
        exam_paper = ExamPaper.create! valid_attributes
        put :update, {:id => exam_paper.to_param, :exam_paper => new_attributes}, valid_session
        exam_paper.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested exam_paper as @exam_paper" do
        exam_paper = ExamPaper.create! valid_attributes
        put :update, {:id => exam_paper.to_param, :exam_paper => valid_attributes}, valid_session
        expect(assigns(:exam_paper)).to eq(exam_paper)
      end

      it "redirects to the exam_paper" do
        exam_paper = ExamPaper.create! valid_attributes
        put :update, {:id => exam_paper.to_param, :exam_paper => valid_attributes}, valid_session
        expect(response).to redirect_to(exam_paper)
      end
    end

    context "with invalid params" do
      it "assigns the exam_paper as @exam_paper" do
        exam_paper = ExamPaper.create! valid_attributes
        put :update, {:id => exam_paper.to_param, :exam_paper => invalid_attributes}, valid_session
        expect(assigns(:exam_paper)).to eq(exam_paper)
      end

      it "re-renders the 'edit' template" do
        exam_paper = ExamPaper.create! valid_attributes
        put :update, {:id => exam_paper.to_param, :exam_paper => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested exam_paper" do
      exam_paper = ExamPaper.create! valid_attributes
      expect {
        delete :destroy, {:id => exam_paper.to_param}, valid_session
      }.to change(ExamPaper, :count).by(-1)
    end

    it "redirects to the exam_papers list" do
      exam_paper = ExamPaper.create! valid_attributes
      delete :destroy, {:id => exam_paper.to_param}, valid_session
      expect(response).to redirect_to(exam_papers_url)
    end
  end

end
