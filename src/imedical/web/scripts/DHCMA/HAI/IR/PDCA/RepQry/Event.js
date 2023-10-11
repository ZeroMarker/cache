//页面Event
function InitPAQryWinEvent(obj) {
	//初始化
	obj.LoadEvent=function(){
		 obj.gridPDCAQryLoad();
		 
		 //查询
    	$("#btnQuery").on('click', function () {
        	obj.gridPDCAQryLoad();
    	});
	}
	//刷新表格
	obj.gridPDCAQryLoad = function(){
		$cm ({
		   	ClassName: "DHCHAI.IRS.PDCARegSrv",
		    QueryName: "QryPARepList",
		    aHospIDs:$('#cboHospital').combobox('getValue'),
		    aDateType:$('#cboDateType').combobox('getValue'),	
		    aDateFrom:$("#DateFrom").datebox('getValue'),	
		    aDateTo:$("#DateTo").datebox('getValue'),	
		    aStatus:$('#cboStatus').combobox('getValue'),	
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridPDCAQry').datagrid({loadFilter:pagerFilter}).datagrid('loadData',rs);					
		});
    }
	//点击'新增'PDCA报告
    $('#custtb > a').click(function (e) {
        var ModTypeID = $(this).attr('text');
        if (ModTypeID=="") {
            $.messager.alert("提示", "PDCA项目为空!", 'info');
        }
        else if (ModTypeID == "btnExport") { //导出
        	var rows 			= obj.gridPDCAQry.getRows();  //返回当前页的所有行
        	if(rows.length==0){
	        	$.messager.alert("错误","当前界面没有数据，无法导出!", 'info');
				return;
	        }
        	
            $('#gridPDCAQry').datagrid('toExcel', 'PDCA项目查询.xls');   //导出
        }
        else{
	    	 obj.OpenPDCARep(ModTypeID,"","",obj.AdminPower);   //打开PDCA报告
	    }
    });
    //检索框
    $('#searchbox').searchbox({
        searcher: function (value, name) {
	        if(value=="") {
		      	obj.gridPDCAQryLoad();
		    } else {
			    searchText($("#gridPDCAQry"), value);
			}           
        }
    });
	//打开PDCA报告
    obj.OpenPDCARep = function (aModTypeID, aReportID,aSubID,aAdminPower) {
        var url = '../csp/dhcma.hai.ir.pdca.report.csp?&RegTypeID=' + aModTypeID + '&ReportID=' + aReportID+ '&SubID=' + aSubID + "&AdminPower=" + obj.AdminPower;
        websys_showModal({
            url: url,
            title: 'PDCA项目登记表',
            iconCls: 'icon-w-paper',
            width: '1320',
            height: '95%',
            onBeforeClose: function () {
                obj.gridPDCAQryLoad();
            }
        });
    }
   
	obj.SendMessage = function() {
		/*var MsgType="MBRMsgCode";
		var Msg = "多耐分类:"+MRBDesc+",检出病原体:"+Bacteria
		var InputStr = AdmID +"^"+ MsgType +"^"+ $.LOGON.USERID + "^" + Msg+"^"+ResultID;
		var retval = $m ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			MethodName:"SendHISMRBMsg",
			ResultSetType:"array",
			aInputStr:InputStr
		})
		if(parseInt(retval)== '-1') {
	        $.messager.alert("提示","发送消息的患者不存在！", 'info');
			return;
        }else if (parseInt(retval)== '-2') {
	        $.messager.alert("提示","HIS多耐消息代码:MBRMsgCode未配置!", 'info');
			return;  
        }else if (parseInt(retval)== '-3') {
	        $.messager.alert("提示","发送消息用户不存在!", 'info');
			return;   
        }else if(parseInt(retval)<1) {
	       $.messager.alert("提示","发送消息失败！", 'info');
			return;    
        }*/
		$.messager.alert("提示","成功向临床医生发送消息！", 'info');
		return;
	}
}