package www.gl.com.coolweather;

import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.SplashScreen;

import static android.os.Build.VERSION.SDK_INT;
import static android.os.Build.VERSION_CODES.M;
import static android.os.Build.VERSION_CODES.O;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            // FlutterActivity会在onCreate中将statusBarColor设为半透明, 这里把它覆盖掉
            getWindow().setStatusBarColor(Color.TRANSPARENT);
        }
        findViewById(android.R.id.content).setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
    }

    @Nullable
    @Override
    public SplashScreen provideSplashScreen() {
        SplashScreen splashScreen = super.provideSplashScreen();
        if (splashScreen == null) {
            return null;
        }
        return new SplashScreen() {
            /**
             * FlutterActivity启动过程中会将windows.decorView的SystemUiVisibility设为[io.flutter.plugin.platform.PlatformPlugin.DEFAULT_SYSTEM_UI]
             * 导致状态栏/导航栏图标变成白色..., 这个值是写死的, 基本上没办法修改
             * 这里通过拦截SplashScreen的View的创建过程, 给它设置SystemUiVisibility, 将状态栏/导航栏图标临时设为灰色
             */
            @Nullable
            @Override
            public View createSplashView(@NonNull Context context, @Nullable Bundle savedInstanceState) {
                View splashView = splashScreen.createSplashView(context, savedInstanceState);
                if (splashView == null) {
                    return null;
                }
                splashView.setSystemUiVisibility(
                        (SDK_INT >= O ? View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR : 0)
                                | (SDK_INT >= M ? View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR : 0)
                );
                return splashView;
            }

            @Override
            public void transitionToFlutter(@NonNull Runnable onTransitionComplete) {
                splashScreen.transitionToFlutter(onTransitionComplete);
            }
        };
    }
}
