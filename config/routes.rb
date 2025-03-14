Rails.application.routes.draw do
  get "slots/index"
  get "slots/slots"
  get "home/index"
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }


  authenticated :user, ->(u) { u.admin? } do
    namespace :admin do
      # resources :departments
      resources :rooms do
        get :report, on: :collection
      end
      resources :beds
      # resources :doctors do
      # resources :slots, only: [:new, :create, :index]
      # end
    end
  end


  namespace :admin do
    get "slots/destriy"
    get "doctors/index", to: "doctors#index", as: :home
    resources :consultations do
      member do
      patch :toggle_bed_assignment
    end
    end
    get "consultations/:id", to: "doctors#download_pdf", as: :download
    delete "consultations/:id", to: "consultations#destroy", as: :destroy

    resources :doctor_profiles do
      get "see/slots", to: "doctors_#see_patients", as: :see_patient
      patch "/:id", to: "admin/doctor_profiles#update", as: :update

      collection do
    get :dashboard  # Doctor's assigned patients page
  end

  member do
    get :download_patient_csv  # Download specific patient consultations as CSV
    get :download_patient_pdf  # Download specific patient consultations as PDF
  end
end
delete "doctor_profiles/:id", to: "doctor_profiles#destroy", as: :admin_doctor_profile_delete
resources :rooms
  post "rooms", to: "rooms#create", as: :create

resources :departments
    # resources :slots
    resources :consultations do
    end
    get "/consultations", to: "consultations#index", as: :index
    # patch 'slots/:id', to: 'slots#update', as: :update_slot
  end

  resources :patients do
    collection do
    get :download_consultations  # Patient downloads their own consultation file
  end
  end

  resources :slots do
    member do
      # patch '/books', to: 'slots#books', as: :booking
      patch :book
    end
  end

  authenticated :user, ->(u) { u.patient? } do
    # namespace :patient do
    get "dashboard", to: "dashboard#index"
    resources :appointments

    # end
  end

  root "home#index"
end
