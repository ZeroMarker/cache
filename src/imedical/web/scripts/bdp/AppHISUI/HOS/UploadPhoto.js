
$(function () {
    var URL = window.URL || window.webkitURL;
    var $image = $("#img")
    //获取图片截取的位置
    var $dataX = $('#dataX');
    var $dataY = $('#dataY');
    var $dataHeight = $('#dataHeight');
    var $dataWidth = $('#dataWidth');
    var $dataRotate = $('#dataRotate');
    var $dataScaleX = $('#dataScaleX');
    var $dataScaleY = $('#dataScaleY');


    var options = {
        aspectRatio: 1 / 1, //裁剪框比例1:1
        preview: '.img-preview',
        crop: function (e) {
            $dataX.val(Math.round(e.detail.x));
            $dataY.val(Math.round(e.detail.y));
            $dataHeight.val(Math.round(e.detail.height));
            $dataWidth.val(Math.round(e.detail.width));
            $dataRotate.val(e.detail.rotate);
            $dataScaleX.val(e.detail.scaleX);
            $dataScaleY.val(e.detail.scaleY);
        }
    };

    $image.cropper(options)

    var cropper = $image.data('cropper');

    $(".button-wrapper").on("click", "[data-method]", function (e) {
        var $this = $(this);
        var method = $this.data("method");
        var $target = $(e.target);
        switch (method) {
            case "zoom+":
                $image.cropper("zoom", 0.1);
                break;
            case "zoom-":
                $image.cropper("zoom", -0.1);
                break;
            case "rotate+90":
                $image.cropper("rotate", -90);
                break;
            case "rotate-90":
                $image.cropper("rotate", 90);
                break;
            case "refresh":
                $image.cropper("reset");
                break;
            case "uploadImage":

                break;
            case "uploadAva":
                var result = $image.cropper("getCroppedCanvas", { MaxWidth: 4096, MaxHeight: 4096 });
				
				function compress(canvas,quality){
					var base64 = canvas.toDataURL('image/jpeg', quality)
					if(base64.length>60000){
						var percentage=base64.length / 80000
						
						if(percentage < 1.5){
							quality = quality - 0.1
						}else{
							quality = quality / percentage
						} 
						if(quality < 0.1){
							quality = 0.1
						}
						if((quality==0.1)&&(base64.length>80000)){
							alert("图片像素过高或选中区域过大,请缩小选中区域或者放大选中")
							return
						}
						return compress(canvas,quality)
						
					}else{
						return base64
					}
					
				}
				var resultBase64 = compress(result,0.7)
				$("#PAPhoto",window.parent.document).val(resultBase64)
				window.parent.$("#myWinUpload").dialog("close");
				/*var SetImg= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUserExtend&pClassMethod=setImg";
				var SSUSRERowId=Ext.BDP.FunLib.getParam('selectrow')
                $.ajax({
					url:SetImg,
					type:"post",
					data:{
						id:SSUSRERowId,
						base64: resultBase64
					},
					datatype:"json",
					success:function(res){
						Ext.Msg.show({
							title:'提示',
							minWidth:200,
							msg:'上传成功!',
							icon:Ext.Msg.OK,
							buttons:Ext.Msg.OK
						});	
					}
				})*/
                break;
        }
    })


    var blobURL;
    var $inputImage = $('#inputImage');
    if (URL) {

        $(".file-wrapper").on("change", "#inputImage", function () {
            var files = this.files;
            var file;
            if (cropper && files && files.length) {
                file = files[0];

                if (/^image\/\w+/.test(file.type)) {
                    blobURL = URL.createObjectURL(file);
                    cropper.reset().replace(blobURL);
                } else {
                    window.alert('Please choose an image file.');
                }
            }
        })

    } else {
        inputImage.disabled = true;
        inputImage.parentNode.className += ' disabled';
    }
})