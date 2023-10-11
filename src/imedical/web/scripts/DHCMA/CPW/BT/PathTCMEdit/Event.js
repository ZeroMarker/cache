//页面Event
function InitPathTCMListWinEvent(obj){
	
	$('#winPathTCMEdit').dialog({
		title: '中药方剂维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	$('#winPathTCMOSEdit').dialog({
		title: '中药方剂-协定处方维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	$('#winPathTCMExtEdit').dialog({
		title: '中药方剂-君臣佐使维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});	
	
	// 检查删除按钮是否允许删除，否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.CPW.BT.PathTCM")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
	if(!chkDelBtnIsAble("DHCMA.CPW.BT.PathTCMExt")){
		$("#btnSubDelete").hide();	
	}else{
		$("#btnSubDelete").show();	
	}
	
    obj.LoadEvent = function(args){ 
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winPathTCMEdit').close();
     	});
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer1();
     	});
		//编辑
		$('#btnEdit').on('click', function(){
	     	var rd=obj.gridPathTCM.getSelected()
			obj.layer1(rd);	
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
		//保存子类
		$('#btnSubSave').on('click', function(){
	     	obj.btnSaveSub_click();
     	});
		//关闭子类
		$('#btnSubClose').on('click', function(){
	     	$HUI.dialog('#winPathTCMExtEdit').close();
     	});
		//删除子类
     	$('#btnSubDelete').on('click', function(){
			if(!obj.RecRowID1)  return;
	     	obj.btnDeleteSub_click();
     	});
		//编辑子类
     	$('#btnSubEdit').on('click', function(){
			if(!obj.RecRowID1)return;
	     	var rd=obj.gridPathTCMExt.getSelected();
			obj.layer2(rd);		
     	});
		//添加子类
     	$('#btnSubAdd').on('click', function(){
			if(!obj.RecRowID1)return;
			obj.layer2();	
     	});
		//协定处方-添加
		$('#btnPathTCMOSAdd').on('click', function(){
			var rd=obj.gridPathTCM.getSelected()
	     	obj.btnPathTCMOSAdd_click(rd);
     	});
		//协定处方-删除
		$('#btnPathTCMOSDel').on('click', function(){
			var rd=obj.gridPathTCMOS.getSelected()
	     	obj.btnPathTCMOSDel_click(rd);
     	});
		//协定处方-保存
		$('#btnTCMOSSave').on('click', function(){
	     	obj.btnTCMOSSave_click();
     	});
		//协定处方-关闭
		$('#btnTCMOSClose').on('click', function(){
	     	$HUI.dialog('#winPathTCMOSEdit').close();
     	});
    }
	
	//选择中药方剂
	obj.gridPathTCM_onSelect = function(){
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID1="";
		var rowData = obj.gridPathTCM.getSelected();
		
		if (rowData==null || (rowData && (rowData["BTID"] == obj.RecRowID1))) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnPathTCMOSAdd").linkbutton("disable");
			$("#btnPathTCMOSDel").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID1="";
			obj.PathTCMExtLoad();
			obj.gridPathTCM.clearSelections();  //清除选中行
		} else {
			obj.RecRowID1 = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.PathTCMExtLoad();  //加载子分类
			obj.PathTCMOSLoad();  //加载协定处方
		}
	}
	//双击编辑事件 父表
	obj.gridPathTCM_onDbselect = function(rd){
		obj.layer1(rd);	
	}
	//选择子项
    obj.gridPathTCMExt_onSelect = function (){
		if($("#btnEdit").hasClass("l-btn-disabled")) return;
		if(!obj.RecRowID1)return;
		if($("#btnSubEdit").hasClass("l-btn-disabled")) obj.RecRowID2="";
		var rowData = obj.gridPathTCMExt.getSelected();
		
		if (rowData["ExtID"] == obj.RecRowID2) {
			$("#btnSubAdd").linkbutton("enable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID2="";
			obj.gridPathTCMExt.clearSelections();  //清除选中行
		} else {
			obj.RecRowID2 = rowData["ExtID"];
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("enable");
			$("#btnSubDelete").linkbutton("enable");	
		}
	}
    //双击编辑事件 子表
	obj.gridPathTCMExt_onDbSelect = function(rd){
		if($("#btnEdit").hasClass("l-btn-disabled")){
			$.messager.alert("错误提示", "请先选择左表中的数据" , 'info');			
			return;
		}
		if(!obj.RecRowID1) return;
		
		obj.layer2(rd);	
	}
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var myDate = new Date();
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		var BTActDate ='';
		var BTActTime='';
		var BTActUserID="";
		if(session['DHCMA.USERID']) BTActUserID=session['DHCMA.USERID'];
	
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathTCM",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID1
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
	  	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + BTActDate;
		inputStr = inputStr + CHR_1 + BTActTime;
		inputStr = inputStr + CHR_1 + BTActUserID;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathTCM",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1,
			aHospID: $("#cboSSHosp").combobox('getValue')
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathTCMEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID1=flg;
			obj.gridPathTCM.reload() ;//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridPathTCM.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathTCM",
					MethodName:"DeleteById",
					aId:rowID,
					aHospID: $("#cboSSHosp").combobox('getValue')
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert("错误提示","系统参数配置不允许删除！", 'info');
					} else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID1="";
					obj.gridPathTCMExt.reload();//刷新当前
					obj.gridPathTCM.reload() ;//刷新当前页	
				}
			} 
		});
	}
	//保存子类
	obj.btnSaveSub_click =  function(){
		var errinfo = "";	
		var inputStr= ""
		var BTOrdMastID = $('#txtOrdMastID').lookup('getText');;
		var BTTypeDr = $('#cboTypeDr').combobox('getValue');
		var DoseQty 	= $('#DoseQty').val();
		var CTUnit 		= $('#CTUnit').combobox('getText');
		var SPriority 	= Common_GetValue('SPriority')?1:0;
		var ArcResume 	= $('#comArcResume').combobox('getValue');
		if (!BTOrdMastID) {
			errinfo = errinfo + "医嘱项不能为空!<br>";
		}
		if(BTTypeDr==""){
			errinfo = errinfo + "类型不能为空!<br>";
		}
		//检查代码是否重复
		if (obj.RecRowID2==""){
			var IsCheck=$m({
				ClassName:"DHCMA.CPW.BT.PathTCMExt",
				MethodName:"CheckBTSDesc",
				aOrdMastID:BTOrdMastID,
				aParref:obj.RecRowID1
			},false);
	  		if(IsCheck==1)
	  		{
	  			errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  		}
			if (errinfo) {
				$.messager.alert("错误提示", errinfo, 'info');
				return;
			}
		}
		
		if(obj.RecRowID2){
			var str=obj.RecRowID2.split('||');
			inputStr = str[0] + CHR_1 + str[1] 
		}else{
			inputStr = obj.RecRowID1 + CHR_1 + "" 
		}
		
		inputStr = inputStr + CHR_1 + BTOrdMastID;
		inputStr = inputStr + CHR_1 + BTTypeDr;
		inputStr = inputStr + CHR_1 + DoseQty;
		inputStr = inputStr + CHR_1 + CTUnit;
		inputStr = inputStr + CHR_1 + SPriority;
		inputStr = inputStr + CHR_1 + ArcResume;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathTCMExt",
			MethodName:"Update",
			aInStr:inputStr,
			aSeparete:CHR_1
		},false);
		//console.log((parseInt(flg)<=0)+flg+inputStr);
		
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!", 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathTCMExtEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 =flg
			obj.gridPathTCMExt.reload() ;//刷新当前页
		}
	}
	//删除子分类
	obj.btnDeleteSub_click = function(){
		var rowData = obj.gridPathTCMExt.getSelected();
		var rowDataID =rowData["BTSID"];
		if ((obj.RecRowID1=="")||(rowDataID=="")){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {
				 var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathTCMExt",
					MethodName:"DeleteById",
					aId:obj.RecRowID1+"||"+rowDataID
				},false);		
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert("错误提示","当前无删除权限，请启用删除权限后再删除记录！", 'info');
					} else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2="";
					obj.gridPathTCMExt.reload() ;//刷新当前页
							
				}							
			}
		});

	}
	//加载子表
	obj.PathTCMExtLoad = function () {
		var ParRef = "";
		if (obj.RecRowID1) {
			ParRef =obj.RecRowID1;
		}
		obj.gridPathTCMExt.load({
			ClassName:"DHCMA.CPW.BTS.PathTCMExtSrv",
			QueryName:"QryPathTCMExt",
			aParRef:ParRef
		});	
	}
	//加载协定处方
	obj.PathTCMOSLoad = function () {
		var PathTCMDr = "";
		if (obj.RecRowID1) {
			PathTCMDr =obj.RecRowID1;
		}
		obj.gridPathTCMOS.load({
			ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",
			QueryName:"QryPathTCMOS",
			aPathTCMDr:PathTCMDr
		});
	}
	//配置窗体-初始化
	obj.layer1= function(rd){
		if(rd){
			obj.RecRowID1=rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var BTIsActive = rd["BTIsActive"];
			BTIsActive = (BTIsActive=="是"? true: false)
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
		}else{
			obj.RecRowID1="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winPathTCMEdit').open();
	}
    //配置窗体-初始化
	obj.layer2= function(rd){
		if(!obj.RecRowID1){
			//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
			$.messager.alert("错误提示","请先选定中药方剂",'info');
			return;
		}	
		
		if(rd){
			obj.RecRowID2	=rd["ExtID"];
			var BTTypeID	= rd["BTTypeID"];
			var BTOrdMastID = rd["BTOrdMastID"];
			var DoseQty 	= rd["DoseQty"];
			var CTUnit 	= rd["CTUnit"];
			var SPriority 	= rd["SPriority"];
			var ArcResume 	= rd["ArcResume"];
			$('#txtOrdMastID').val(BTOrdMastID);
			$('#cboTypeDr').combobox('setValue',BTTypeID);	
			Common_SetValue('DoseQty',DoseQty);
			Common_SetValue('CTUnit',CTUnit);
			if (SPriority=="是") SPriority=1;
			else SPriority=0;
			Common_SetValue('SPriority',SPriority);
			if(ArcResume==""||ArcResume=="undefined"){
				$('#comArcResume').combobox('setText',"");
				Common_SetValue('comArcResume',"");
			}else{
				Common_SetValue('comArcResume',ArcResume);
			}
		}else{
			obj.RecRowID2 ="";
			$('#txtOrdMastID').val('');	
			$('#cboTypeDr').combobox('setValue','');	
			Common_SetValue('DoseQty','');
			Common_SetValue('CTUnit','');
			Common_SetValue('SPriority','');
			Common_SetValue('comArcResume','');	
		}
		$HUI.dialog('#winPathTCMExtEdit').open();
	}
	//协定处方-添加
	obj.btnPathTCMOSAdd_click = function(rd){
		if (!rd) return;
		var PathTCMDr = rd["BTID"];
		
		$('#txtTCMOSDesc').searchbox({
			searcher:function(value,name){
				obj.gridTCMOSList.load({
					ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",
					QueryName:"QryTCMOSByAlias",
					aPathTCMDr:PathTCMDr,
					aAlias:value
				});
			},
			prompt:'请输入筛查关键词...'
		});
		
		obj.gridTCMOSList.load({
			ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",
			QueryName:"QryTCMOSByAlias",
			aPathTCMDr:PathTCMDr,
			aAlias:''
		});
		$HUI.dialog('#winPathTCMOSEdit').open();
		$('#txtTCMOSDesc').searchbox('setValue', null);
	}
	//协定处方-删除
	obj.btnPathTCMOSDel_click = function(rd){
		var errinfo = "";
		var PathTCMOSDrs = '';
		var rowsData = $('#gridPathTCMOS').datagrid('getChecked');
		for (var i = 0;i<rowsData.length;i++) {
			var TCMOSDr=rowsData[i].TCMOSDr;
			if (!TCMOSDr) continue;
			if (PathTCMOSDrs == '') {
				PathTCMOSDrs = TCMOSDr;
			} else {
				PathTCMOSDrs += ',' + TCMOSDr;
			}
		}
		var ActUserID="";
		if(session['DHCMA.USERID']) ActUserID=session['DHCMA.USERID'];
		
		if (!PathTCMOSDrs) {
			errinfo = errinfo + "未选择协定处方!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {
				var flg = $m({
					ClassName:"DHCMA.CPW.BTS.PathTCMOSSrv",
					MethodName:"DeleteTCMOS",
					aIDs:PathTCMOSDrs,
					aActUserID:ActUserID
				},false);
				if (parseInt(flg) <= 0) {
					$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.gridPathTCMOS.reload() ;//刷新当前页
				}
			}
		});
	}
	//协定处方-保存
	obj.btnTCMOSSave_click = function(){
		var errinfo = "";
		var ARCOSIDs = '';
		var rowsData = $('#gridTCMOSList').datagrid('getChecked');
		for (var i = 0;i<rowsData.length;i++) {
			var ARCOSID=rowsData[i].ARCOSID;
			if (!ARCOSID) continue;
			if (ARCOSIDs == '') {
				ARCOSIDs = ARCOSID;
			} else {
				ARCOSIDs += ',' + ARCOSID;
			}
		}
		var ActUserID="";
		if(session['DHCMA.USERID']) ActUserID=session['DHCMA.USERID'];
		
		if (!ARCOSIDs) {
			errinfo = errinfo + "未选择协定处方!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + ARCOSIDs;
		inputStr = inputStr + CHR_1 + ActUserID;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BTS.PathTCMOSSrv",
			MethodName:"AddTCMOS",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		} else {
			$HUI.dialog('#winPathTCMOSEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridPathTCMOS.reload() ;//刷新当前页
		}
	}
	//协定处方-列表选择
    obj.gridPathTCMOS_onClickRow = function (){
		if($("#btnEdit").hasClass("l-btn-disabled")) return;
		if(!obj.RecRowID1)return;
		var rowsData = obj.gridPathTCMOS.getSelected();
		if (rowsData){
			$("#btnPathTCMOSAdd").linkbutton("enable");
			$("#btnPathTCMOSDel").linkbutton("enable");
		}
	}
	//中药方剂剂量单位 dsp
	obj.CTUnit=function(rowDate){
		var rstData = $cm({ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",MethodName:"GetArcimInfoById",aArcimID:rowDate.ArcimID,dataType:'text'},false);
		var rstArr = rstData.split("^");
		obj.cboCTUnit = $HUI.combobox("#CTUnit",{
				url:$URL+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryDoseUomByArcim&aArcimID="+rowDate.ArcimID+"&ResultSetType=array",
				valueField:'DoseUomID',
				textField:'DoseUomDesc'
		});
		$('#CTUnit').combobox('setValue',rstArr[4]);
	}
}