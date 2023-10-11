var com_openwin=(function(){
	function ShowPatBody(DCARowId,ShowFlag){
		if(DCARowId==""){
			$.messager.alert("警告","请选择一条已申请的治疗申请.")
	        return false
		}
		if ("undefined"==typeof ShowFlag){ShowFlag="";}
		var dhwid=1000; //$(window).width()+50;
		var dhhei=650; //$(window).height()-10;
		websys_showModal({
			url:"doccure.apply.bodyset.hui.csp?EpisodeID=" + ServerObj.EpisodeID+"&DCARowId="+DCARowId+"&ShowFlag="+ShowFlag,
			title:$g('治疗人体部位图'),
			iconCls:"icon-w-plus",
			width:dhwid,
			height:dhhei,
			AddBodyNoteToPlan:AddBodyNoteToPlan
		});
	}
	function AddBodyNoteToPlan(BodyNote){
		if(BodyNote=="")return;
		var ApplyPlan=$("#ApplyPlan").val();
		ApplyPlan=ApplyPlan+String.fromCharCode(13)+BodyNote;
		$("#ApplyPlan").val(ApplyPlan);
	}
	
	function ShowCureRecordDiag(argObj){
		var myArgObj={
			DCAARowId:"",
			DCRRowId:"",
			OEORERowID:"",
			DCATempId:"",
			QueId:"",
			Source:"",
			callback:""
		}
		$.extend(myArgObj,argObj)
		if(myArgObj.DCRRowId==""){
			var jsonStr=$.cm({
				ClassName:"DHCDoc.DHCDocCure.Record",
				MethodName:"GetRowIdStr",
				dataType:"text",
				DCAARowIdStr:myArgObj.DCAARowId,
				OEORERowIDStr:myArgObj.OEORERowID
			},false);
			if(jsonStr!=""){
				var obj=JSON.parse(jsonStr); 
				var Len=obj.List.length;
				if(Len>0){
					function Loop(j){
						new Promise(function(resolve,rejected){
							var oneObj=obj.List[j];
							var DCAAdmId=oneObj.DCAAdmId;
							var DCATempId=oneObj.DCATempId;
							var DCAARowIdStr=oneObj.DCAARowIdStr;
							var OEORERowIDStr=oneObj.OEORERowIDStr;
							var aArgObj={};
							$.extend(aArgObj,myArgObj);
							aArgObj.DCAARowId=DCAARowIdStr;
							aArgObj.OEORERowID=OEORERowIDStr;
							aArgObj.DCATempId=DCATempId;
							aArgObj.callback=resolve;
							OpenCureRecord(aArgObj);
						}).then(function(value){
							myArgObj.callback(value);
							j++;
							if ( j < Len ) {
								 Loop(j);
							}else{
								
							}
						})
					}
					Loop(0);
				}	
			}
		}else{
			OpenCureRecord(myArgObj)	
		}
	}
	function OpenCureRecord(ArgObj){
		
		if(typeof ArgObj != "object"){
			$.messager.alert("提示","获取必要参数错误", 'error');
			return	
		}
		var myArgObj={
			DCAARowId:"",
			OEORERowID:"",
			DCATempId:"",
			QueId:"",
			Source:"",
			DCRRowId:"",
			PageShowFromWay:ServerObj.PageShowFromWay
		}
							
		$.extend(myArgObj,ArgObj)
		var myhref="";
		var diagW="1200px";
		var diagH="600px";
		if(myArgObj.DCATempId==""){
			//$.messager.alert("提示","未获取到治疗记录模板", 'error');
			//return;
			myhref="doccure.curerecord.hui.csp"+"?DCAARowIdStr="+myArgObj.DCAARowId+"&OperateType=ZLYS&DCRRowId="+myArgObj.DCRRowId+"&OEORERowIDS="+myArgObj.OEORERowID+"&source="+myArgObj.Source;
		}else{
			var DHCDocCureRecordLinkPage=ArgObj.DHCDocCureRecordLinkPage;
			if(DHCDocCureRecordLinkPage.indexOf(".csp")>-1){
				var arr=DHCDocCureRecordLinkPage.split("&");
				myhref=arr[0];
				if(arr.length>1){
					diagW=arr[1].split("=")[1];
				}
				if(arr.length>2){
					diagH=parseInt(arr[2].split("=")[1]);
				}
			}else{
				myhref="doccure.recordtemp.hui.csp";	
			}
			myhref=myhref+"?DCAARowIdStr="+myArgObj.DCAARowId+"&OperateType=ZLYS&DCRRowId="+myArgObj.DCRRowId+"&OEORERowIDS="+myArgObj.OEORERowID+"&source="+myArgObj.Source+"&DCRTempID="+myArgObj.DCATempId+"&QueId="+myArgObj.QueId+"&PageShowFromWay="+myArgObj.PageShowFromWay;
			//+"?DCARowId="+DCARowId+"&DCAssRowId="+DCAssRowId+"&OperateType="+$('#OperateType').val()+"&DCRowIDStr="+DCRowIDStr+"&DCAssTempID="+AssTempID+"&DCAdmID="+AssAdmID+"&PageShowFromWay="+ServerObj.PageShowFromWay;
		}
		if(myArgObj.DCRRowId!=""){
			var mTitle="浏览治疗记录";
			var mIconCls="icon-w-eye";	
		}else{
			var mTitle="新增治疗记录";
			var mIconCls="icon-w-add";			
		}
	    websys_showModal({
			url:myhref,
			title:$g(mTitle),
			iconCls:mIconCls,
			width:diagW,height:diagH,
			onClose:ArgObj.callback
		});
	}
	function ShowApplyDetail(DCARowId,DHCDocCureLinkPage,callback){
		var href="doccure.apply.update.hui.csp";
		var wd="65%";
		var ht="95%";
		if(DHCDocCureLinkPage.indexOf(".csp")>-1){
			//var arr=DHCDocCureLinkPage.split("&");
			//href=arr[0];
			href=DHCDocCureLinkPage.split(".csp")[0]+".csp";
		}
		href=href+"?DCARowId="+DCARowId;
	    websys_showModal({
			url:href,
			title:$g('申请单浏览'),
			iconCls:"icon-w-eye",
			width:wd,
			height:ht,
			callbackFun:callback
		});
	}
	
	function ShowReportTrace(DCARRowID,DCAARowID,OEORERowID) {
		if(typeof DCAARowID=="undefined"){
			DCAARowID="";	
		}
		if(typeof OEORERowID=="undefined"){
			OEORERowID="";	
		}
		var width = $(document.body).width() - 200;
		var height = 350;
		websys_showModal({
			url:"doccure.curerecord.trace.hui.csp?DCARRowID="+DCARRowID+"&DCAARowID="+DCAARowID+"&OEORERowID="+OEORERowID,
			title:$g('治疗过程追踪'),
			iconCls:'icon-w-plus',
			width:width,
			height:height
		});
		/*$("#win_ReportTrace").window({
			modal:true,
			title:'治疗过程追踪',
			iconCls:"icon-track",
			collapsible:false,
			iconCls:'icon-message',
			width:width,
			height:height,
			content:'<iframe src="doccure.curerecord.trace.hui.csp?DCARRowID='+DCARRowID+'&DCAARowID='+DCAARowID+'&OEORERowID='+OEORERowID+'" scrolling="no" frameborder="0" style="width:100%;height:90%;"></iframe>'
			//top: xy.top+20,
			//left: xy.left-width+100
		});*/
	}
	
	function ordDetailInfoShow(OrdRowID){
		websys_showModal({
			url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
			title:$g('医嘱明细'),
			iconCls:'icon-w-trigger-box',
			width:400,height:'90%'
		});
	}
	function applyAppenditemShow(OrdRowID){
		websys_showModal({
			url:"doccure.apply.appenditem.hui.csp?ordRowId=" + OrdRowID,
			title:$g('医嘱及绑定信息'),
			iconCls:'icon-w-trigger-box',
			width:'80%',height:'90%'
		});
	}
	return{
		"ShowPatBody":ShowPatBody,
		"ShowCureRecordDiag":ShowCureRecordDiag,
		"ShowApplyDetail":ShowApplyDetail,
		"ShowReportTrace":ShowReportTrace,
		"ordDetailInfoShow":ordDetailInfoShow,
		"applyAppenditemShow":applyAppenditemShow
	}
})()