# 🌤️ Glasscast - iOS Weather App

A beautiful, modern weather app built with SwiftUI and powered by AI-assisted development. Features real-time weather data, user authentication, favorite cities, and seamless temperature unit conversion.

## ✨ Features

- **Real-time Weather Data** - Current weather and 5-day forecast
- **Beautiful Glass-morphism UI** - Modern, translucent design
- **User Authentication** - Secure login/signup with Supabase
- **Favorite Cities** - Save and manage your favorite locations
- **Temperature Units** - Switch between Celsius (°C) and Fahrenheit (°F)
- **Smart Search** - Search cities with autocomplete
- **Offline Support** - Graceful error handling and loading states

  ### Home Screen
  <img src="https://github.com/user-attachments/assets/2565144b-410b-47fa-a4a6-2fc71f8b195a" width="300" />


### Search & Favorites
<img src="https://github.com/user-attachments/assets/0ab01ba4-2859-4b7f-8c7e-6d705f98a258" width="300" />



### Settings
<img src="https://github.com/user-attachments/assets/d935d159-5570-4c0d-84c9-f89fff8fb999" width="300" />




## 🛠️ Tech Stack

- **Frontend**: SwiftUI with MVVM Architecture
- **Backend**: Supabase (Auth + PostgreSQL with RLS)
- **Weather API**: OpenWeatherMap
- **Authentication**: Supabase Auth
- **Database**: Supabase PostgreSQL
- **Package Manager**: Swift Package Manager

### Dependencies
- [Supabase Swift SDK](https://github.com/supabase/supabase-swift) v2.40.0
- Swift Concurrency (async/await)
- URLSession for networking

## 🚀 Getting Started

### Prerequisites

- **Xcode 15.0+** with iOS 15.0+ SDK
- **macOS Ventura 13.0+**
- **OpenWeatherMap API Key** (free tier available)
- **Supabase Account** (free tier available)

### 1. Clone the Repository

```bash
git clone https://github.com/asthaarora108/Glasscast-iOS.git
cd Glasscast-iOS
```

### 2. Open in Xcode

```bash
open Glasscast.xcodeproj
```

### 3. Configure Supabase

#### Option A: Use the Existing Supabase Project (Recommended for testing)

The app is pre-configured to use a demo Supabase project. The credentials are already in the code:

```swift
// Glasscast/Services/SupabaseClient.swift
struct SupabaseConfig {
    static let url = URL(string: "https://qiikaaunpcmsgyzmitkl.supabase.co")!
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### Option B: Set Up Your Own Supabase Project

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to Settings → API
3. Copy your Project URL and anon/public key
4. Update `SupabaseClient.swift`:

```swift
struct SupabaseConfig {
    static let url = URL(string: "YOUR_SUPABASE_URL")!
    static let anonKey = "YOUR_SUPABASE_ANON_KEY"
}
```

5. Create the database tables:

```sql
-- Create favorites table
CREATE TABLE favorite_cities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    city_name TEXT NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    lon DOUBLE PRECISION NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE favorite_cities ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own favorites" ON favorite_cities
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own favorites" ON favorite_cities
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own favorites" ON favorite_cities
    FOR DELETE USING (auth.uid() = user_id);
```

### 4. Configure OpenWeatherMap

1. Sign up at [openweathermap.org](https://openweathermap.org)
2. Get your free API key from the dashboard
3. The app will prompt you to enter the API key on first launch

### 5. Build and Run

Select an iOS simulator or device, then press `Cmd + R` to build and run.

## 📁 Project Structure

```
Glasscast/
├── Models/
│   ├── FavoriteCity.swift      # Favorite city data model
│   ├── Forecast.swift          # Weather forecast model
│   └── Weather.swift           # Current weather model
├── Services/
│   ├── SupabaseClient.swift    # Supabase configuration
│   ├── WeatherService.swift    # OpenWeatherMap API client
│   └── FavoriteCityService.swift # Favorites CRUD operations
├── ViewModels/
│   ├── AuthViewModel.swift     # Authentication logic
│   ├── WeatherViewModel.swift  # Weather data management
│   └── FavoriteCityViewModel.swift # Favorites management
├── Views/
│   ├── AuthView.swift          # Login/signup screen
│   ├── ForecastView.swift      # Main weather display
│   ├── SearchView.swift        # City search and favorites
│   ├── SettingsView.swift      # App settings and preferences
│   ├── MainTabView.swift       # Tab bar navigation
│   └── RootView.swift          # Authentication state routing
├── Components/
│   └── GlassStyle.swift        # UI styling and themes
└── Assets.xcassets/            # App icons and colors
```

## 🏗️ Architecture

### MVVM Pattern
- **Models**: Data structures and business logic
- **ViewModels**: UI state management and data transformation
- **Views**: Pure UI components with declarative SwiftUI

### Key Principles
- **Separation of Concerns**: Each layer has a single responsibility
- **Reactive Programming**: SwiftUI's state-driven updates
- **Error Handling**: Comprehensive error states and user feedback
- **Security**: No hardcoded secrets, secure API key storage

## 🔧 API Reference

### OpenWeatherMap Endpoints Used
- `GET /data/2.5/weather` - Current weather data
- `GET /data/2.5/forecast` - 5-day weather forecast

### Supabase Tables
- `favorite_cities` - User favorite locations with coordinates

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **AI-Assisted Development**: Built with the help of Claude AI
- **SwiftUI Community**: For inspiration and best practices
- **Supabase Team**: For the amazing backend-as-a-service platform
- **OpenWeatherMap**: For providing free weather data API

## 📞 Support

If you have any questions or need help:
- Open an issue on GitHub
- Check the CLAUDE.md file for AI development context
- Review the code comments for implementation details

---

**Made with ❤️ using SwiftUI and AI assistance**
