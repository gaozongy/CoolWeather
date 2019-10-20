package www.gl.com.coolweather.net;

import com.gzy.www.myapplication.bean.WeatherBean;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;

public interface ApiService {

    @GET("{longitude},{latitude}/weather.json?dailysteps=6")
    Call<WeatherBean> weather(@Path("longitude") double longitude, @Path("latitude") double latitude);
}