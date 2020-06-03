// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package www.gl.com.coolweather.widget;

import android.animation.Animator;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.android.DrawableSplashScreen;
import io.flutter.embedding.android.SplashScreen;
import www.gl.com.coolweather.R;

/**
 * {@link DrawableSplashScreen}: 使用了{@link android.widget.ImageView#setImageDrawable(Drawable)} 设置预览图, 在执行alpha动画时
 * {@link R.drawable#launch_background}的背景和前景透明度变化看起来不一样...
 * <p>
 * 该类替换成使用{@link View#setBackground(Drawable)}设置预览图, 规避该问题
 * <p>
 * {@link SplashScreen} that displays a given {@link Drawable}, which then fades its alpha to zero
 * when instructed to {@link #transitionToFlutter(Runnable)}.
 */
public final class BackgroundDrawableSplashScreen implements SplashScreen {
    private final Drawable drawable;
    private final long crossfadeDurationInMillis;
    private View splashView;

    /**
     * Constructs a {@code DrawableSplashScreen} that displays the given {@code drawable} and
     * crossfades to Flutter content in 500 milliseconds.
     */
    public BackgroundDrawableSplashScreen(@NonNull Drawable drawable) {
        this(drawable, 300);
    }

    /**
     * Constructs a {@code DrawableSplashScreen} that displays the given {@code drawable} and
     * crossfades to Flutter content in the given {@code crossfadeDurationInMillis}.
     *
     * <p>
     * @param drawable The {@code Drawable} to be displayed as a splash screen.
     */
    public BackgroundDrawableSplashScreen(
            @NonNull Drawable drawable,
            long crossfadeDurationInMillis) {
        this.drawable = drawable;
        this.crossfadeDurationInMillis = crossfadeDurationInMillis;
    }

    @Nullable
    @Override
    public View createSplashView(@NonNull Context context, @Nullable Bundle savedInstanceState) {
        splashView = new View(context);
        splashView.setBackground(drawable);
        return splashView;
    }

    @Override
    public void transitionToFlutter(@NonNull Runnable onTransitionComplete) {
        if (splashView == null) {
            onTransitionComplete.run();
            return;
        }

        splashView
                .animate()
                .alpha(0f)
                .setDuration(crossfadeDurationInMillis)
                .setListener(
                        new Animator.AnimatorListener() {
                            @Override
                            public void onAnimationStart(Animator animation) {
                            }

                            @Override
                            public void onAnimationEnd(Animator animation) {
                                onTransitionComplete.run();
                            }

                            @Override
                            public void onAnimationCancel(Animator animation) {
                                onTransitionComplete.run();
                            }

                            @Override
                            public void onAnimationRepeat(Animator animation) {
                            }
                        });
    }
}
