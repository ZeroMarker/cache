
function InitKBaseWinEvent(obj){
	//初始查询条件
	$('button').on('click', function() {
		obj.KBList();
	})
	$('#textKey').on('keydown',function (e) {
        if (e.keyCode == 13) {
           obj.KBList();
        }
    })
    $('#cboGC').on('keydown',function (e) {
        if (e.keyCode == 13) {
           obj.KBList();
        }
    })
    $('#cboType').on('keydown',function (e) {
        if (e.keyCode == 13) {
           obj.KBList();
        }
    })
    $('#cboYear').on('keydown',function (e) {
        if (e.keyCode == 13) {
           obj.KBList();
        }
    })
	obj.KBList=function(){
		var Year=($('#cboYear').val()=="请选择年份")?"":$('#cboYear').val();
		var Type=($('#cboType').val()=="请选择专科类型")?"":$('#cboType').val();;
		var PubType=($('#cboGC').val()=="请选择版本类型")?"":$('#cboGC').val();;
		$m({
			ClassName: "DHCMA.CPW.KBS.PathBaseSrv",
			MethodName: "GetKBInfo",
			aKeyValue:$('#textKey').val(),
			aYear:Year,
			aType:Type,
			aPubType:PubType
		}, function (JsonStr) {	
			var InfoHtml=""
			$('#KBInfo').html(InfoHtml);
			$('#KBCount').html("")
			if (JsonStr == ""){
				$("#workD").hide();
			 	$("#workS").show();
				return;
			} 
			 $("#workS").hide();
			 $("#workD").show();
			var JsonObj = $.parseJSON(JsonStr);	
			$('#KBCount').html("为您找到"+JsonObj.length+"条结果")
			for(var i=0;i<JsonObj.length;i++){
				var InfoHtml=InfoHtml+'<div class=\"Infocontent hisui-linkbutton\" style=\"font-size:1.3em;padding:10px 0;\">【路径】 <a onclick=\"obj.OpenWinPDF(\'' + JsonObj[i].BTPDFPath+ '\')\" style=\"cursor:pointer\">'+JsonObj[i].BTDesc+'临床路径</a><a title=\"表单预览\" onclick=\"obj.OpenForm(\'' + JsonObj[i].BTID+ '\')\" style=\"padding-left:40px;cursor:pointer\" class=\"icon-eye"></a><a title=\"导出excel\" onclick=\"obj.ExportForm(\'' + JsonObj[i].BTID+'\',\''+JsonObj[i].BTDesc +'\')\" style=\"padding-left:25px;cursor:pointer\" class=\"icon-export-report"></a></div>'
				//var InfoHtml=InfoHtml+'<div class="Infocontent" style="font-size:1.3em;padding:10px 0;">【路径】 '+JsonObj[i].BTDesc+'临床路径</div>'
				var InfoHtml=InfoHtml+'<div class=\"Infocontent\" style=\"padding-bottom:10px;\">专科类型：'+JsonObj[i].BTType+'</div>'
				var InfoHtml=InfoHtml+'<div class=\"Infocontent\" style=\"padding-bottom:10px;\">路径关键字：'+JsonObj[i].BTKeys+'</div>'
				var InfoHtml=InfoHtml+'<div class=\"Infocontent\" style=\"padding-bottom:10px;\">适用对象：'+JsonObj[i].BTSuitInfo+'</div>'
				var InfoHtml=InfoHtml+'<div class=\"Infocontent\" style=\"padding-bottom:10px;\">进入路径标准：'+JsonObj[i].BTInPathStd+'</div>'
				var InfoHtml=InfoHtml+'<div class=\"Infocontent\" style=\"padding-bottom:10px;\">变异分析描述：'+JsonObj[i].BTPVDesc+'</div>'
				var InfoHtml=InfoHtml+'<div style=\"padding-bottom:10px;border-bottom:1px solid #ccc">'
					var InfoHtml=InfoHtml+'<span class=\"Infocontent\" style=\"padding-right:50px;\">发布年份：'+JsonObj[i].BTYear+'</span>'
					var InfoHtml=InfoHtml+'<span class=\"Infocontent\">发布类型：'+JsonObj[i].BTPubType+'</span>'
				var InfoHtml=InfoHtml+'</div>'
				//console.log(InfoHtml)
				//$('#KBInfo').html(InfoHtml);
				$('#KBInfo').append(InfoHtml);
				var InfoHtml=""
			}
			
		})
	}
	
	//打开PDF文档
	obj.OpenWinPDF = function(argPath){
		websys_showModal({
			url:'../../med/Results/Template/MA/CPW/KBDoc/' + argPath,
			title:'路径文档',
			iconCls:'icon-w-paper',     
			width:1200,
			height:window.screen.availHeight-100
		});	
	}
	
	//预览表单
	obj.OpenForm=function(FormBaseID){
		websys_showModal({
			url:"./dhcma.cpw.kb.viewform.csp?1=1" +"&PathFormID=" + FormBaseID  ,
			title:"表单预览",
			iconCls:'icon-w-eye',  
			closable:true,
			originWindow:window,
			width:1400,
			height:650
		})
	}
	
	//导出excel格式表单
	obj.ExportForm=function(FormBaseID,FormName){
			ExportForm(FormBaseID,FormName);
	};
}