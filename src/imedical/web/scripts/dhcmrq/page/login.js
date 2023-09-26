
$(function () {
    if (getCookie("CookieIsRemember") == 'true') {
	    //console.log(getCookie("CookieIsRemember"))
        $("#username").val(getCookie("CookieUserName"));
        $("#password").val(getCookie("CookieUserPwd"));
        $("#isRemember").attr("checked", true);
    }

    $("#password").keydown(function (event) {
        if (event.which == 13 || event.which == 9) {
            login();
        }
    });
    $("#username").keydown(function (event) {
        if (event.which == 13 || event.which == 9) {
            $("#password").focus();
        }
    });
//})
//$(function() {
		var textArray=['完整性','准确性','得分','优','良','排名','分布','评价'];
		var color = ['#FBAF4F','#92C831','#FF897B','#9E93E1','#34D7DF'];
		var canvas = document.getElementById('bg_canvas');
		//canvas.width = $(window).width()*0.4;
		canvas.height = $(window).height()-200;
		canvas.style.marginTop=-($(window).height()-200)*0.5+'px';
		$(window).resize(function() {
			//canvas.width = $(window).width()*0.4;
			canvas.height = $(window).height()-200;
			canvas.style.marginTop=-($(window).height()-200)*0.5+'px';
		})
		var context = canvas.getContext('2d');
		context.globalCompositeOperation='destination-over';
		var Point = function(x,y) {
			if(x && y){
				this.x = x;
				this.y = y;
			} else {
				this.x = canvas.width/2;//Math.random() * canvas.width;
				this.y = canvas.height/2;//Math.random() * canvas.height;
			}
			this.r = Math.random() * 5+20;
			this.vx = Math.random()-0.5;
			this.vy = Math.random()-0.5;
			this.vr = this.r*0.001;
			this.maxR = this.r*1.5;
			this.minR = this.r*0.5;
			this.g = -0;//Math.random()*0.2;
			this.text = textArray[(Math.random() * (textArray.length-1)).toFixed(0)];
			this.color = color[(Math.random() * (color.length-1)).toFixed(0)];
			this.lineColor = 'rgba(255,255,255,'+ (Math.random() * (0.6-0.2) + 0.2).toFixed(1) + ')';
		}
		var ps = [];
		for (var i = 0; i < 5; i++) {
			ps.push(new Point());
		}

		//ps.length=0;
		function doAnimation(){
			draw(context);
			update();

			requestAnimationFrame(doAnimation);
		}
		//doAnimation();

		// $('body').off('mouseup');
		// $('body').on('mouseup', function(e) {
		// 	if(ps.length<20){
		// 		var cp = getPointOnCanvas(canvas, e.clientX, e.clientY);
		// 		ps.push(new Point(cp.x,cp.y));
		// 	}
		// });
		$('body').off('mousemove');
		$('body').on('mousemove', function(e) {
			var cp = getPointOnCanvas(canvas, e.clientX, e.clientY);
			var r = 20;
			for (var i = 0; i < ps.length; i++) {
				if (ps[i].x < (cp.x+r) && ps[i].x > (cp.x-r) && ps[i].y < (cp.y+r) && ps[i].y > (cp.y-r)) {
					ps[i].x = cp.x;
					ps[i].y = cp.y;
				}
			}
		});

		function draw(cxt) {
			var cv = cxt.canvas;
			cxt.clearRect(0, 0, cv.width, cv.height);
			cxt.save();

			for (var i = 0; i < ps.length; i++) {
				cxt.beginPath();
				cxt.shadowColor='rgba(0,0,0,0.2)';
				cxt.shadowBlur=40;
				cxt.shadowOffsetY=150;
				cxt.arc(ps[i].x, ps[i].y, ps[i].r, 0, Math.PI * 2);
				cxt.fillStyle = ps[i].color;
				cxt.fill();

				cxt.font=ps[i].r*0.5+'px 微软雅黑';
				cxt.fillStyle = '#FFFFFF';//ps[i].lineColor;
				cxt.globalCompositeOperation="source-over";
				cxt.fillText(ps[i].text, ps[i].x-ps[i].x*0.05, ps[i].y+ps[i].y*0.05);
				cxt.globalCompositeOperation="destination-over";

				cxt.fillStyle = ps[i].color;
				if (i > 0) {
					cxt.moveTo(ps[i - 1].x, ps[i - 1].y);
				} else {
					cxt.moveTo(ps[0].x, ps[0].y);
				}

				cxt.lineTo(ps[i].x, ps[i].y);
				cxt.lineWidth=2;
				cxt.strokeStyle = ps[i].lineColor;
				cxt.stroke();
			}

			cxt.restore();
		}

		function update() {
			for (var i = 0; i < ps.length; i++) {
				ps[i].x += ps[i].vx;
				ps[i].y += ps[i].vy;
				ps[i].r += ps[i].vr;
				ps[i].vy = ps[i].vy - ps[i].g;

				if (ps[i].x+ps[i].r >= canvas.width-20 || ps[i].x-ps[i].r < 0) {
					ps[i].vx = -ps[i].vx;
				}
				if (ps[i].y+ps[i].r >= canvas.height-20 || ps[i].y-ps[i].r < 0) {
					ps[i].vy = -ps[i].vy;
				}
				if (ps[i].r >= ps[i].maxR || ps[i].r <= ps[i].minR) {
					ps[i].vr = -ps[i].vr;
				}
			}
		}

		function getPointOnCanvas(canvas, x, y) {
			var box = canvas.getBoundingClientRect();

			return {x:x - box.left,y:y - box.top};

		}
})


var isok = false;
function login() {
		//console.log(md5(123456));
    if (isok) {
        return;
    }
    isok = true;
    $.ajax({
        type: 'post',
        url: 'dhcmrq.service.csp',
        data: {ClassName:'DHCMRQ.Base.Logon',
			   MethodName:'UserLogon',
			   Params:$('#username').val()+','+$('#password').val()
			  },
        success: function (res) {
	        //console.log(res)
	        var res = JSON.parse(res)
	        //console.log(res)
            isok = false;
            if (res.IsLogin == true && res.IsSuccess == true) {
	            //console.log($("#isRemember").is(":checked"))
	            setCookie("CookieIsRemember", $("#isRemember").is(":checked"));
                if ($("#isRemember").is(":checked")) {
                    setCookie("CookieUserName", $("#username").val());
                    setCookie("CookieUserPwd", $("#password").val());
                }
                else {
                    setCookie("CookieUserName", "");
                    setCookie("CookieUserPwd", "");
                }
                //$('#loginForm').msg('success',res['Msg']);
                window.location.href = 'dhcmrq.index.csp';
            }
            else {
                $('#loginForm').msg('danger',res['Msg']);
            }
        }
    });
}
function setCookie(name, value) {//两个参数，一个是cookie的名子，一个是值
    var Days = 30; //此 cookie 将被保存 30 天
    var exp = new Date();    //new Date("December 31, 9998");
    exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
    document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
}

function getCookie(name) {//取cookies函数
    var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
    if (arr != null) return unescape(arr[2]); return null;
}
$.fn.msg = function(type,msg){
	var icon = {
		info:'fa-info-circle',
		success:'fa-check-circle',
		danger:'fa-exclamation-circle'
	}
	var alert = $('<div class="alert alert-'+type+' alert-dismissible" role="alert">'
				+	'<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>'
				+	'<i class="fa '+icon[type]+'"></i><span class="text">' + msg +'</span>'
				+'</div>');
	$(this).after(alert);
	setTimeout(function () {
		alert.fadeOut();
	}, 2000);
}