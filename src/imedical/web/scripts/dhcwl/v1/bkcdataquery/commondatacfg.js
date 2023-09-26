
var initFun = function(){
	var rptInfo;
	/*
	function getFieldValues(formID){
		var values=new Object();
		var selector="form#"+formID+" input";
		$(selector).each(function(){
			if (!$(this).attr("name")) return;
			//alert($(this).attr("name")+":"+$(this).val());
			values[$(this).attr("name")]=$(this).val();
		});
		
		return values;
		
	}
	*/
	
	//通用方法：设置表单值
	function setFieldValue(formID,fieldName,value) {
		$("div#"+formID+" [name='"+fieldName+"']").val(value);		
	};	
	///清除配置
	$("#btnClearCfg").click(function (argument) {
		$('#rptCfgDiv').find('input').val("");
	});
	
	
	$HUI.dialog("#rptcfg-saveDlg",{
		title:'另存',
		iconCls:'icon-w-add',
		
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,			
		
		
		buttons:[{
			//id:'btnPrevID',
			text:'确定',
			handler:OnSaveAsConfirm
		},{
			//id:'btnNextID',
			text:'取消',
			handler:OnSaveCancel
		}]
		});	
	///保存配置
	$("#btnSaveCfg").click(function (argument) {
		
		flag = $("#ConfigForm").form("validate");   //表单内容合法性检查
		if (!flag){
			$.messager.alert("提示","请按照提示填写信息");
			return;
		}		

		var otherParam=getFieldValues("ConfigForm").OtherParam;
		var reg=/[\(\)\'\,]/;
		if(reg.test(otherParam)){
			$.messager.alert("提示","【其他参数】中不能包括 ( , ) , '  以及英文逗号等特殊字符！");	
			return;
		}
		
				
		if (rptID=="") {
			setFieldValues("saveForm",{Name:"",Code:"",Descript:""});
			$('#rptcfg-saveDlg').dialog('open');			
		}else{
			SaveRpt("save");
		}
		//getFieldValues('rptCfgDiv');
	});
	
	///保存配置
	$("#btnSaveAsCfg").click(function (argument) {
		
		flag = $("#ConfigForm").form("validate");   //表单内容合法性检查
		if (!flag){
			$.messager.alert("提示","请按照提示填写信息");
			return;
		}	
		
		
		var otherParam=getFieldValues("ConfigForm").OtherParam;
		
		var reg=/[\(\)\'\,]/;
		if(reg.test(otherParam)){
			$.messager.alert("提示","【其他参数】中不能包括 ( , ) , '  以及英文逗号等特殊字符！");	
			return;
		}		
		
		
		/*
		$HUI.dialog("#rptcfg-saveDlg",{
			title:'另存',
			iconCls:'icon-w-add',
			
			resizable:false,
			modal:true,
			position: ['center','center'],
			autoOpen: false,			
			
			
			buttons:[{
				//id:'btnPrevID',
				text:'确定',
				handler:OnSaveAsConfirm
			},{
				//id:'btnNextID',
				text:'取消',
				handler:OnSaveCancel
			}]
			});	
		*/
		setFieldValues("saveForm",{Name:"",Code:"",Descript:""});
		
		$('#rptcfg-saveDlg').dialog('open');			

	});	
	
	///Creator：      wz
	///CreatDate：    2018-11
	///Description:：   解析日期字符串
	///Table：       
	///Input：            日期字符串
	///Output：          
	///Return：         date对象
	///Others：        	
	///	example:		

	function dhcwlDateParser(strDate) {
		return $.fn.datebox.defaults.parser(strDate);
	}
	///Creator：      wz
	///CreatDate：    2018-11
	///Description:：   将date对象转换成字符串
	///Table：       
	///Input：          date：日期对象；format：字符串格式。目前支持"YMD"。separator:字符串分隔符
	///Output：          
	///Return：         
	///Others：        	
	///	example:
	function dhcwlDateFormat(date,format,separator) {
		if (!format) format="YMD";
		if (!separator) separator="-";
		var y = date.getFullYear();
		var m = date.getMonth()+1;
		var d = date.getDate();
		
		if (format=="YMD") {
			//return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;
			return y+separator+(m<10?('0'+m):m)+separator+(d<10?('0'+d):d);
		}
		//其他格式在此添加。
		/*else if () {	
			
			
		}
		*/
	}	
	
	///保存配置
	$("#btnPreview").click(function (argument) {
		if (!rptID) {
			$.messager.alert("提示","请先保存或另存配置后再进行预览！");	
			return;
		}
		
		var dateValues=getFieldValues("DataRangeForm");
		if (dateValues.startDate=="" || dateValues.endDate=="") {
			$.messager.alert("提示","请录入‘开始日期’和‘结束日期’后再进行预览！");	
			return;			
			
		}
		
		//var strDate=$('#startDate').datebox('getValue');
		var strDate=dateValues.startDate;
		var objDate =dhcwlDateParser(strDate);
		var strStartDate=dhcwlDateFormat(objDate);
		
		strDate=dateValues.endDate;
		objDate =dhcwlDateParser(strDate);
		var strEndDate=dhcwlDateFormat(objDate);

		
		
		
		
		$('#rptShowDiv').empty();
		/*
		var rows=$('#gridSearchCondition').datagrid('getData').rows;
		
		var startDate=rows[0].value;			
		var endDate=rows[1].value;
		
		var rows=$('#gridRptConfigs').datagrid('getData').rows;
		var dataObj=new Object();
		for(var i=0;i<rows.length;i++){
			dataObj[rows[i].code]=rows[i].value;
		}
		*/
		//var dateValues=getFieldValues("DataRangeForm");
		var src='dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-commonDataQry2_1.raq';
		//src=src+'&startDate='+dateValues.startDate+'&endDate='+dateValues.endDate;
		src=src+'&startDate='+strStartDate+'&endDate='+strEndDate;
		src=src+'&rptID='+rptID;
		var compand='<iframe src='+src+' width=100% height=100%  frameborder="0"></iframe>'
		
		$(compand).appendTo("#rptShowDiv");			
	});
	

	function OnSaveCancel() {
		$('#rptcfg-saveDlg').dialog('close');
	}
	function OnSaveAsConfirm() {
		flag = $("#saveForm").form("validate");   //表单内容合法性检查
		if (!flag){
			$.messager.alert("提示","请按照提示填写信息");
			return;
		}		
		var values=getFieldValues("saveForm");
		var code=values.Code;
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.CommonDataServ",
			MethodName:"GetRptIdByCode",
			rptCode:code
		},function(jsonData){
				if (jsonData.success==1) {
					if (jsonData.ID!="") {
						$.messager.alert("提示","该编码已被使用！请修改编码后再试。");
					}else{
						SaveRpt("saveAs",null,values);
						

						
						$('#rptcfg-saveDlg').dialog('close');
					}
					//window.parent.$HUI.datagrid("#browseGrid","reload");					
					
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
		});	
	}	
	
	function SaveRpt(saveType,funCallback,savedRptInfo) {
		var values=getFieldValues("ConfigForm");
		var MN="";
		if(saveType=="save") {
			type="UpdateRpt"
		}else if (saveType=="saveAs") {
			type="InsertRpt"
		}; 		
		
		var Code="";
		var PdtType="";
		var Descript="";
		var RptName="";	
		if (savedRptInfo!=null) {
			Code=savedRptInfo.Code;
			PdtType=savedRptInfo.BusinessType;
			Descript=savedRptInfo.Descript;
			RptName=savedRptInfo.Name;			
		}
	
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.CommonDataServ",
			MethodName:"SaveRpt",
			wantreturnval:0,
			actType:type,
			
			ID:rptID,
			
			Routine:values.Routine,
			Fun:values.Fun,
			NameSpace:values.NameSpace,
			OtherParam:values.OtherParam,
			
			Code:Code,
			UserID:userID,
			PdtType:PdtType,
			Descript:Descript,
			RptName:RptName			
		},function(jsonData){
				$.messager.alert("提示",jsonData.msg);
				if (jsonData.success==1) {
					if (type=="InsertRpt") {
						rptInfo=savedRptInfo;
						rptID=jsonData.rowid;
						$('#actLabel').html("编辑 - "+rptInfo.Name);
					}
				}
				
				//刷新父窗口
				window.parent.$HUI.datagrid("#browseGrid","reload");
		});		
		
					
	};	
	

	if (inAct=="edit") {
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.CommonDataServ",
			MethodName:"LoadCDQRptCfg",	
			wantreturnval:0,
			rptID:rptID
			},function(jsonData){
				if(jsonData.success==1){
					var rows=jsonData.rows[0];
					var x;
					for(x in rows) {
						setFieldValue("rptCfgDiv",x,rows[x]);
					}
					$('#actLabel').html("编辑 - "+rows.RptName);
					
				}
			})
			
	}else if  (inAct=="add") {
		$('#actLabel').html("新增");
		rptID="";
		
	}else if  (inAct=="") {
		//OnLoadConfirm();
	}	
		
};

	
	

$(initFun);
