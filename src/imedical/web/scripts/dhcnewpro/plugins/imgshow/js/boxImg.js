/**
 * Created by TF on 2018/1/15.
 */
 function initShowImg(){
var len = $("img[modal='zoomImg']").length;
var arrPic = new Array(); //����һ������
for (var i = 0; i < len; i++) {
    arrPic[i] = $("img[modal='zoomImg']").eq(i).prop("src"); //������img·���洢��������
}

$("img[modal='zoomImg']").each(function () {
    $(this).on("click", function () {
        //��body��ӵ������html
        $("body").append("<div class=\"mask-layer\">" +
            "   <div class=\"mask-layer-black\"></div>" +
            "   <div class=\"mask-layer-container\">" +
            "       <div class=\"mask-layer-container-operate\">" +
            "           <button class=\"mask-prev btn-default-styles\" style=\"float: left\">"+$g("��һ��")+"</button>" +
            "           <button class=\"mask-out btn-default-styles\">"+$g("�Ŵ�")+"</button>" +
            "           <button class=\"mask-in btn-default-styles\">"+$g("��С")+"</button>" +
            "           <button class=\"mask-clockwise btn-default-styles\">"+$g("˳ʱ��")+"</button>" +
            "           <button class=\"mask-counterclockwise btn-default-styles\">"+$g("��ʱ��")+"</button>" +
            "           <button class=\"mask-close btn-default-styles\">"+$g("�ر�")+"</button>" +
            "           <button class=\"mask-next btn-default-styles\" style=\"float: right\">"+$g("��һ��")+"</button>" +
            "       </div>" +
            "       <div class=\"mask-layer-imgbox auto-img-center\"></div>" +
            "   </div>" +
            "</div>"
        );

        var $this = $(this);
        var img_index = $this.attr("index"); //��ȡ���������ֵ
        var num = img_index;

        function showImg() {
            $(".mask-layer-imgbox").append("<p><img src=\"\" alt=\"\"></p>");
            $(".mask-layer-imgbox img").prop("src", arrPic[num]); //���������Img��ֵ

            //ͼƬ������ʾ
            var box_width = $(".auto-img-center").width(); //ͼƬ���ӿ��
            var box_height = $(".auto-img-center").height();//ͼƬ�߶ȸ߶�
            var initial_width = $(".auto-img-center img").width();//��ʼͼƬ���
            var initial_height = $(".auto-img-center img").height();//��ʼͼƬ�߶�
            if (initial_width > initial_height) {
                $(".auto-img-center img").css("width", box_width);
                var last_imgHeight = $(".auto-img-center img").height();
                $(".auto-img-center img").css("margin-top", -(last_imgHeight - box_height) / 2);
            } else {
                $(".auto-img-center img").css("height", box_height);
                var last_imgWidth = $(".auto-img-center img").width();
                $(".auto-img-center img").css("margin-left", -(last_imgWidth - box_width) / 2);
            }

            //ͼƬ��ק
            var $div_img = $(".mask-layer-imgbox p");
            //����������ס�¼�
            $div_img.bind("mousedown", function (event) {
                event.preventDefault && event.preventDefault(); //ȥ��ͼƬ�϶���Ӧ
                //��ȡ��Ҫ�϶��ڵ������
                var offset_x = $(this)[0].offsetLeft;//x����
                var offset_y = $(this)[0].offsetTop;//y����
                //��ȡ��ǰ��������
                var mouse_x = event.pageX;
                var mouse_y = event.pageY;
                //���϶��¼�
                //�����϶�ʱ�����������Ƴ�Ԫ�أ�����Ӧ��ʹ��ȫ�֣�document��Ԫ��
                $(".mask-layer-imgbox").bind("mousemove", function (ev) {
                    // ��������ƶ��˵�λ��
                    var _x = ev.pageX - mouse_x;
                    var _y = ev.pageY - mouse_y;
                    //�����ƶ����Ԫ������
                    var now_x = (offset_x + _x ) + "px";
                    var now_y = (offset_y + _y ) + "px";
                    //�ı�Ŀ��Ԫ�ص�λ��
                    $div_img.css({
                        top: now_y,
                        left: now_x
                    });
                });
            });
            //���������ɿ����Ӵ��¼���
            $(".mask-layer-imgbox").bind("mouseup", function () {
                $(this).unbind("mousemove");
            });

            //����
            var zoom_n = 1;
            $(".mask-out").click(function () {
                zoom_n += 0.1;
                $(".mask-layer-imgbox img").css({
                    "transform": "scale(" + zoom_n + ")",
                    "-moz-transform": "scale(" + zoom_n + ")",
                    "-ms-transform": "scale(" + zoom_n + ")",
                    "-o-transform": "scale(" + zoom_n + ")",
                    "-webkit-": "scale(" + zoom_n + ")"
                });
            });
            $(".mask-in").click(function () {
                zoom_n -= 0.1;
                console.log(zoom_n)
                if (zoom_n <= 0.1) {
                    zoom_n = 0.1;
                    $(".mask-layer-imgbox img").css({
                        "transform":"scale(.1)",
                        "-moz-transform":"scale(.1)",
                        "-ms-transform":"scale(.1)",
                        "-o-transform":"scale(.1)",
                        "-webkit-transform":"scale(.1)"
                    });
                } else {
                    $(".mask-layer-imgbox img").css({
                        "transform": "scale(" + zoom_n + ")",
                        "-moz-transform": "scale(" + zoom_n + ")",
                        "-ms-transform": "scale(" + zoom_n + ")",
                        "-o-transform": "scale(" + zoom_n + ")",
                        "-webkit-transform": "scale(" + zoom_n + ")"
                    });
                }
            });
            //��ת
            var spin_n = 0;
            $(".mask-clockwise").click(function () {
                spin_n += 15;
                $(".mask-layer-imgbox img").parent("p").css({
                    "transform":"rotate("+ spin_n +"deg)",
                    "-moz-transform":"rotate("+ spin_n +"deg)",
                    "-ms-transform":"rotate("+ spin_n +"deg)",
                    "-o-transform":"rotate("+ spin_n +"deg)",
                    "-webkit-transform":"rotate("+ spin_n +"deg)"
                });
            });
            $(".mask-counterclockwise").click(function () {
                spin_n -= 15;
                $(".mask-layer-imgbox img").parent("p").css({
                    "transform":"rotate("+ spin_n +"deg)",
                    "-moz-transform":"rotate("+ spin_n +"deg)",
                    "-ms-transform":"rotate("+ spin_n +"deg)",
                    "-o-transform":"rotate("+ spin_n +"deg)",
                    "-webkit-transform":"rotate("+ spin_n +"deg)"
                });
            });
            //�ر�
            $(".mask-close").click(function () {
                $(".mask-layer").remove();
            });
            $(".mask-layer-black").click(function () {
                $(".mask-layer").remove();
            });
        }
        showImg();

        //��һ��
        $(".mask-next").on("click", function () {
            $(".mask-layer-imgbox p img").remove();
            num++;
            if (num == len) {
                num = 0;
            }
            showImg();
        });
        //��һ��
        $(".mask-prev").on("click", function () {
            $(".mask-layer-imgbox p img").remove();
            num--;
            if (num == -1) {
                num = len - 1;
            }
            showImg();
        });
    })
});

}

var LINK_CSP="dhcapp.broker.csp";
//��ǰ����
var editIndex = undefined;
/**
 * �����к�̨����
 * @creater zhouxin
 * @param className ������
 * @param methodName ������
 * @param datas ����{}
 * @param �ص�����
 * runClassMethod("web.DHCAPPPart","find",{'Id':row.ID,'Name':row.Name},function(data){ alert() },"json")	 
 */
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	

	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}
function serverCall(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return ret.responseText
}