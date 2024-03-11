
package com.example.polygonal_draft;

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.view.View
import android.view.animation.Animation
import android.view.animation.AnimationSet
import android.view.animation.AnimationUtils
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.example.polygonal_draft.MainActivity
import com.example.polygonal_draft.R


class SplashScreen : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_splash_screen)

        val project_name: TextView = findViewById(R.id.project_name);
        val developer_name: TextView = findViewById(R.id.name);

        project_name.visibility = View.INVISIBLE

        val rotateAnimation = AnimationUtils.loadAnimation(this, R.anim.triple_rotate)
        val opacityAnimation = AnimationUtils.loadAnimation(this, R.anim.opacity_up_and_slide)
        val scaleUpAnimationWithRotate = AnimationUtils.loadAnimation(this, R.anim.transform_scale_and_opacity)

    val rotateDuration : Long = 1000
    val opacityDuration : Long = 2000
    val scaleUpDuration : Long = 2000

    val totalAnimationDuration : Long = rotateDuration + opacityDuration + scaleUpDuration


    scaleUpAnimationWithRotate.setAnimationListener(object : Animation.AnimationListener {
    override fun onAnimationStart(animation: Animation) {}

    override fun onAnimationEnd(animation: Animation) {
        developer_name.startAnimation(rotateAnimation)
        project_name.visibility = View.VISIBLE
        project_name.startAnimation(opacityAnimation)
    }

    override fun onAnimationRepeat(animation: Animation) {}
    })
        developer_name.startAnimation(scaleUpAnimationWithRotate)


    Handler().postDelayed({
        val intent = Intent(this, MainActivity::class.java)
        startActivity(intent)
        finish()
    }, totalAnimationDuration)
    }
}