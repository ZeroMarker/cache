//页面Event
function InitPatFindWinEvent(obj){
	obj.LoadEvent = function(args){ 
		
		$("#btnQuery").on('click',function(){
			obj.reloadgridAdm();
		});
		$("#btnClear").on('click',function(){
			obj.btnClear_click();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
	}
	//查询
	obj.reloadgridAdm = function(){
		var ErrorStr="";
		var HospIDs 	= $("#cboHospital").combobox('getValue');
		if(HospIDs==undefined){HospIDs=""}
		var DateType	= $("#cboDateType").combobox('getValue');
		if(DateType==undefined){DateType=""}
		var DateFrom 	= $("#DateFrom").datebox('getValue');
		var DateTo 		= $("#DateTo").datebox('getValue');
		var LocationID  = $("#cboLocation").combobox('getValues');
		if(LocationID==undefined){LocationID=""}
		var WardID	 	= $("#cboWard").combobox('getValues');
		if(WardID==undefined){WardID=""}
		var Items		= $("#cboItems").combobox('getValues');
		if(Items==undefined){Items=""}
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= $("#txtPapmiNo").val();
		var MrNo 		= $("#txtMrNo").val();
		var Relation    = $('#cboRelation').combobox('getValue');
		
		if ((PatName=="")&&(PapmiNo=="")&&(MrNo=="")&&(DateType=="")&&(DateFrom=="")&&(DateTo=="")) {
			$.messager.alert("错误提示","请选择或输入查询条件！", 'info');
			return;
		} else { 
			if  (((PatName=="")&&(PapmiNo=="")&&(MrNo==""))&&((HospIDs!="")||(DateType!="")||(DateFrom!="")||(DateTo!=""))) {   
				var ErrorStr = "";
				if (HospIDs=="") {
					ErrorStr += '请选择院区!<br/>';
				}
				if (DateType=="") {
					ErrorStr += '请选择日期类型!<br/>';
				}
				if (DateFrom=="") {
					ErrorStr += '请选择开始日期!<br/>';
				}
				if (DateTo == "") {
					ErrorStr += '请选择结束日期!<br/>';
				}
				if ((DateFrom!="")&&(DateTo!="")&&(Common_CompareDate(DateFrom,DateTo))) {
					ErrorStr += '开始日期不能大于结束日期!<br/>';
				}
				if (ErrorStr != '') {
					$.messager.alert("错误提示",ErrorStr, 'info');
					return;
				}
			}else{
				if ((PatName=="")&&(PapmiNo=="")&&(MrNo=="")){
					$.messager.alert("错误提示",'请输入检索条件！', 'info');
					return;
				}
			}
		}
		
		obj.gridAdmLoad();
		obj.gridAdm.clearSelections();
	};
	
	//登记号补零 length位数
	var length=10;
	obj.PapmiNo=""
	$("#txtPapmiNo").keydown(function(event){
		 if (event.keyCode ==13) {
			obj.PapmiNo = $("#txtPapmiNo").val();
			if(!obj.PapmiNo) return;
			$("#txtPapmiNo").val((Array(length).join('0') + obj.PapmiNo).slice(-length)); 
			obj.reloadgridAdm();
		}
	});	
	//获取弹窗方式 0为窗口 1为csp
	obj.flg = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"IsShowModal"
		},false);
		//获取当前页面的缩放值
	function detectZoom() {
		var ratio = 1;
		if(BrowserVer=="isChrome") {   //医为浏览器为 Chrome 49
			var userAgent = navigator.userAgent;
            var ChromePos = userAgent.indexOf("Chrome");  //Chrome定位
            var ChromeStr = userAgent.substr(ChromePos);  //Chrome串
            var ChromeArr = ChromeStr.split(" ");
            var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome版本
			if (ChromeVer<=58) {    
				ratio = window.devicePixelRatio;
			}
		}
		return ratio;
	}
	 //摘要
	 obj.btnAbstractMsg_Click = function(EpisodeID)
	 {	
		var ratio =detectZoom();
		var PageWidth=Math.round(1320*ratio);
		 var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
		 //var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		 if(obj.flg=="1"){
			 websys_showModal({
				 url:url,
				 title:'医院感染集成视图',
				 iconCls:'icon-w-epr',
				 closable:true,
				 width:PageWidth,
				 height:'95%'
			 });
		 }
		 else{
			 websys_createWindow(url,"","width="+PageWidth+",height=95%");
		 }	
	 };	
	
	//电子病历
	obj.btnEmrRecord_Click = function(EpisodeID,PatientID)
	{		
		var ratio =detectZoom();
		var PageWidth=Math.round(1320*ratio);
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';	
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:'电子病历',
				iconCls:'icon-w-epr',
				closable:true,
				width:PageWidth,
				height:'95%'
			});
		}
		else{
			websys_createWindow(strUrl,"","width="+PageWidth+",height=95%");
		}		
	};
	
	// 新建院感报告
    obj.btnReprot_Click= function (EpisodeID) {
		var ratio =detectZoom();
		var PageWidth=Math.round(1320*ratio);
		var strUrl = '../csp/dhcma.hai.ir.inf.report.csp?EpisodeID='+EpisodeID+'&1=1';
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:'院感报告',
				iconCls:'icon-w-epr',
				closable:true,
				width:PageWidth,
				height:'95%'
			});
		}
		else{
			var page=websys_createWindow(strUrl,"","width="+PageWidth+",height=95%");
			//var page=websys_createWindow(strUrl,"","width=auto,height=95%");
		}	
    };
    //清楚按钮
	obj.btnClear_click = function(){
		$('#cboHospital').combobox('setValue','');
		$('#cboDateType').combobox('setValue','');
		$('#DateFrom').datebox('setValue','');
		$('#DateTo').datebox('setValue','');
		$('#cboLocation').combobox('setValues','');
		$('#cboWard').combobox('setValues','');
		$('#cboItems').combobox('setValues','');
		$('#cboRelation').combobox('setValue','');
		$('#txtPatName').val('');
		$('#txtPapmiNo').val('');
		$('#txtMrNo').val('');
		$('#cboDischStatus').combobox('setValue','');
	}
	obj.gridAdmLoad = function(){
		
		var HospIDs 	= $("#cboHospital").combobox('getValue');
		var DateType	= $("#cboDateType").combobox('getValue');
		var DateFrom 	= $("#DateFrom").datebox('getValue');
		var DateTo 		= $("#DateTo").datebox('getValue');
		var LocationID  = $("#cboLocation").combobox('getValues');
		var WardID	 	= $("#cboWard").combobox('getValues');
		var Items		= $("#cboItems").combobox('getValues');
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= $("#txtPapmiNo").val();
		var MrNo 		= $("#txtMrNo").val();
		var Relation    = $('#cboRelation').combobox('getValue');
		var IsDeath     = $('#cboDischStatus').combobox('getValue');
		
		var aInputs = HospIDs+'^'+DateType+'^'+DateFrom+'^'+DateTo+'^'+LocationID+'^'+WardID+'^'+PatName+'^'+PapmiNo+'^'+MrNo+'^'+Items+"^"+Relation+"^"+IsDeath;
		
		obj.gridAdm.load({
		    ClassName:"DHCHAI.DPS.PAAdmSrv",
			QueryName:"QryAdm",
			aIntputs:aInputs,
			aPatInfo:'',
	    });
    }
	
	//导出
	obj.btnExport_click = function() {
		var rows=$("#gridAdm").datagrid('getRows').length;
		if (rows>0) {
			$('#gridAdm').datagrid('toExcel','病例列表.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
}

