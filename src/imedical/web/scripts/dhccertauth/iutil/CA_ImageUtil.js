/*
 * 功能描述：转换签名图格式
 * 接口定义：ca_imageutil.ConvertImage(imageBase64, convertFlag, heightStr)
 * 参数定义：imageBase64 ：图片Base64
 * 			 convertFlag ：转换标识，多个标识使用|分隔，transSize|transBackgroud|transSharpening|transDeepth
 *                         transSize 是否转换签名图尺寸，值域：Y/N
 *                         transBackgroud 是否转换签名图背景色为白色，值域：Y/N
 *                         transSharpening 是否对签名图做锐化处理，值域：Y/N
 *                         transDeepth 是否转换图片位深度（预留），值域：Y/N
 *                         示例：Y|Y|N|N
 * 			 heightStr   ：签名标准高度，单位像素
 * 调用示例：var convertedBase64 = ca_imageutil.ConvertImage(imageBase64, "Y|Y|N|N", "180");
 */
var ca_imageutil = (function() {
	
	var CA_EMRImageUtil = "";
	
	function getObj() {
		if (CA_EMRImageUtil != "") return CA_EMRImageUtil;
		
		if("undefined"==typeof(EnableLocalWeb) || 0==EnableLocalWeb ){
			//未开启使用中间件 或 老项目，然仍用老的方式运行
			if ((window.ActiveXObject)||("ActiveXObject" in window)) {
				EMRImageUtil = document.createElement("object");
				EMRImageUtil.setAttribute("id","EMRImageUtil");
				EMRImageUtil.setAttribute("name","EMRImageUtil");
				EMRImageUtil.setAttribute("style","display:none;position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
				EMRImageUtil.setAttribute("classid","clsid:946E2CE5-A392-4744-A94B-02A1ED68DC9F");
				EMRImageUtil.setAttribute("codebase","../addins/plugin/EMRImageUtil/EMRImageUtil.cab#version=1,0,0,0");
				document.documentElement.appendChild(EMRImageUtil);
			}
			
			CA_EMRImageUtil = {
				ConvertImage : function(imageBase64, convertFlag, heightStr){
					try {
						return EMRImageUtil.ConvertImage(imageBase64, convertFlag, heightStr);
					} catch (e) {
						alert("请查看电子病历插件[EMRImageUtil]配置");
						return "";
					}
				}
			}
		}else{
			//中间件运行,此处的 EMRImageUtil 为配置界面的调用ID
			debugger;
			EMRImageUtil.notReturn = 0;
			CA_EMRImageUtil = {
				ConvertImage : function(imageBase64, convertFlag, heightStr){
					try {
						var ret = EMRImageUtil.ConvertImage(imageBase64, convertFlag, heightStr);
						if (ret.status == "200") {
							return ret.rtn;
						} else {
							alert("医为客户端服务异常:" + ret.msg);
							return "";
						}
					} catch (e) {
						alert("医为客户端服务异常");
						return "";
					}
				}
			}
		}
		
		return CA_EMRImageUtil;
	}
	
    return {
		/*
		 * <summary>
         * 转换图片
         * </summary>
         * <param name="imageBase64">图片Base64</param>
         * <param name="convertFlag">transSize|transBackgroud|transSharpening|transDeepth</param>
         * <param name="height">高度，单位像素</param>
		 */
		ConvertImage:function(imageBase64, convertFlag, heightStr) {
			return getObj().ConvertImage(imageBase64, convertFlag, heightStr);
		}
    }
})();