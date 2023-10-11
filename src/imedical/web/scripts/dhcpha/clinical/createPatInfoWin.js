
/// Creator:    bianshuai
/// CreateDate: 2014-06-17
/// Descript:   病人就诊信息窗口
var orditm=""
function createPatInfoWin(adm,patno)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	
	var offsetWidth=document.body.offsetWidth-100;
	var offsetHeight=document.body.offsetHeight-50;

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');
	//iframe 直接加在tab的div中
	//$('#tab').append('<div id="pal" title=$g("过敏记录"><iframe scrolling="yes" width=100% height=100%  frameborder="0" src=""></iframe></div>');
	$('#ptab').append('<div id="pal" title='+$g("过敏记录")+'></div>');
	$('#ptab').append('<div id="ris" title='+$g("检查记录")+'></div>');
	$('#ptab').append('<div id="lab" title='+$g("检验记录")+'></div>');
	$('#ptab').append('<div id="epl" title='+$g("药历浏览")+'></div>');
	$('#ptab').append('<div id="ord" title='+$g("医嘱单")+'></div>');
	$('#ptab').append('<div id="oper" title='+$g("手术信息")+'></div>');
	$('#ptab').append('<div id="med" title='+$g("用药建议")+'></div>');
	$('#ptab').append('<div id="consultpat" title='+$g("会诊查询")+'></div>');
	$('#ptab').append('<div id="emr" title='+$g("病历浏览")+'></div>');

	$('#win').window({
		title:$g('病人检查检验信息'),
		collapsible:true,
		border:true,
		closed:"true",
		width:offsetWidth,   	/// 1200,
		height:offsetHeight,   	/// 550,
		minimizable:false,					/// 隐藏最小化按钮
		maximizable:false,						/// 最大化(qunianpeng 2018/3/12)
		onClose:function(){
			$('#win').remove();  			/// 窗口关闭时移除win的DIV标签
			}
	}); 
	$('#ptab').tabs({    
	    border:false,
	    fit:true, 
	    onSelect:function(title){
	        var tab = $('#ptab').tabs('getSelected'); 		 		/// 获取选择的面板
	        var tbId = tab.attr("id");
	        var maintab="";
	        var IsOnlyShowPAList="";
	        switch(tbId){
	            case "pal":
					//maintab="dhcpha.comment.paallergy.csp";  		/// 过敏记录
					//maintab="dhcem.allergyenter.csp";               /// 过敏记录
					maintab="dhcdoc.allergyenter.csp";               /// 过敏记录
					IsOnlyShowPAList="Y"
					break;
				case "ris":
					//maintab="dhcpha.comment.risquery.csp";   		/// 检查记录
					//maintab="dhcem.inspectrs.csp";                  /// 检查记录
					maintab="dhcapp.inspectrs.csp";                 /// 检查记录
					break;
				case "lab":
					// maintab="dhcpha.comment.labquery.csp";		/// 检验记录  现在接口报错  //qunianpeng 2016-09-07
					//maintab="jquery.easyui.dhclaborder.csp"; 
					//maintab="dhcem.seepatlis.csp";                  /// 检验记录
					maintab="dhcapp.seepatlis.csp";                  /// 检验记录
					break;
				case "epl":
					//maintab="dhc.epr.public.episodebrowser.csp";  /// 药历浏览
					maintab="dhcpha.clinical.drugbrows.csp";
					break;
				case "ord":
					//maintab="dhcpha.comment.queryorditemds.csp";  /// 本次医嘱
					maintab="dhcpha.clinical.queryorditemds.csp";   /// 医嘱单 qunianpeng 2018/3/13
					break;
				case "oper":
					maintab="dhcpha.clinical.operquery.csp";  		/// 手术信息
					break;
				case "med":
					maintab="dhcpha.clinical.medadvises.csp";  		/// 用药建议
					break;
				case "consultpat":
					//maintab="dhcem.consultmain.csp";  		            /// 会诊列表
					maintab="dhcem.consultpathis.csp";
					break;
				case "emr":
				    maintab="emr.browse.manage.csp";
			}
			if(typeof AppType=="undefined"){AppType="";}

			//iframe 定义
			var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'?PatientID='+patno+'&EpisodeID='+adm+'&AppType='+AppType+'&ORditm='+orditm+'&IsOnlyShowPAList='+IsOnlyShowPAList+'&MWToken='+websys_getMWToken()+'"></iframe>';
	        tab.html(iframe);
	        tab.panel('refresh');
			
			var ieset = navigator.userAgent;
			if (ieset.indexOf("MSIE 6.0") > -1){
				var currTab1 = $('#ptab').tabs('getSelected');
				setTimeout(refreshTab=function(refresh_tab){
					if (refresh_tab && refresh_tab.find('iframe').length > 0) {
						var _refresh_ifram = refresh_tab.find('iframe')[0];
						var refresh_url = _refresh_ifram.src;
						_refresh_ifram.contentWindow.location.href = refresh_url;
					}
				},0);
			}
	    }
	});
	$('#ptab').tabs('select',$g('过敏记录')); //默认选中项
	$('#win').window('open');
}
function medadvises(ORditm){
	orditm=ORditm
	$('#ptab').tabs('select',$g('用药建议'));
	}
