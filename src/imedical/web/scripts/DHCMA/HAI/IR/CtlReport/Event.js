function InitReportWinEvent(obj){
	var CheckFlg = 0;  
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}
	obj.LoadEvent = function(args){
		obj.reloadgridApply();
		obj.LoadDataCss();
		obj.LoadPatInfo();
	}
	
	//展现病人基本信息
	obj.LoadPatInfo = function (){
		obj.AdmInfo = $cm({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			QueryName:"QryAdmInfo",	
			aEpisodeID: EpisodeID
		},false);
		if (obj.AdmInfo.total>0) {
			var AdmInfo = obj.AdmInfo.rows[0];
			$('#txtRegNo').val(AdmInfo.PapmiNo);
			$('#txtName').val(AdmInfo.PatName);
			$('#txtSex').val(AdmInfo.Sex);
			$('#txtAge').val(AdmInfo.Age);
			$('#txtBed').val(AdmInfo.AdmBed);
			$('#txtNo').val(AdmInfo.MrNo);
			$('#txtAdmDate').val(AdmInfo.AdmDate);
			$('#txtDischDate').val(AdmInfo.DischDate);
			$('#txtMainTreat').val(AdmInfo.MainDiag);
			
		}
	}
	
	//展示报告信息
	obj.ReportInfo = function(aResultID,aMRBRepID){	
		
		//先清空
    	//$HUI.radio('input[type=radio][name=chkInfType]').uncheck();
		$HUI.radio('input[type=radio][name=chkInsulatType]').uncheck();
		$HUI.radio('input[type=radio][name=chkTreatMent]').uncheck();
		$HUI.radio('input[type=radio][name=chkEnvMent]').uncheck();
		$HUI.radio('input[type=radio][name=chkClothMent]').uncheck();
		$HUI.radio('input[type=radio][name=Assess]').uncheck();
		
		$HUI.checkbox('input[type=checkbox][name=chkContactList]').uncheck();	
		//$HUI.checkbox('input[type=checkbox][name=chkDropletList]').uncheck();	
		$HUI.checkbox('input[type=checkbox][name=chkPlaceList]').uncheck();	
		$HUI.checkbox('input[type=checkbox][name=chkUnitList]').uncheck();	
		$HUI.checkbox('input[type=checkbox][name=chkVisitList]').uncheck();	
		$HUI.checkbox('input[type=checkbox][name=chkEndList]').uncheck();
		$HUI.checkbox('input[type=checkbox][name=chkDoTS]').uncheck();	
		$('#txtResume').val("");		
		$('#txtComments').val("");
		if (obj.MRBOutLabType!="外院携带"){
			var Flg=$cm({
				ClassName:"DHCHAI.IR.INFMBR",
				MethodName:"CheckIsMap",
				aResultID:aResultID
			},false);
			if(parseInt(Flg)== '-1'){
				$.messager.alert("提示","本条记录中标本未维护标准名称对照，请先维护标本标准名称!", 'info');
				return ;	
			}else if (parseInt(Flg)== '-2') {
				$.messager.alert("提示","本条记录中细菌未维护标准名称对照，请先维护细菌标准名称!", 'info');
	            return ;     
		    }else if (parseInt(Flg)== '-3') {
			    $.messager.alert("提示","本条记录中细菌不是多重耐药菌，请先维护多重耐药菌分类!", 'info');
		        return ;     
		    }
		}
	    var RepStatus="";
	    if (aMRBRepID) { //赋值
			var objInfo = $m({    			 //获取数据               
				ClassName:"DHCHAI.IRS.INFMBRSrv",
				MethodName:"GetReportString",
				aRepID:aMRBRepID
			},false);
			if (!objInfo) return;
			var RepInfo = $m({                  
				ClassName:"DHCHAI.IRS.INFMBRSrv",
				MethodName:"GetMBRRepID",
				aEpisodeDr:EpisodeID,
				aINFMBRID:aMRBRepID
			},false);
			if (RepInfo){
				RepDate=RepInfo.split("^")[1];
				RepUser=RepInfo.split("^")[3];
				RepStatus=RepInfo.split("^")[5];				
				$('#txtUpdateUser').val(RepUser);
				$('#txtUpdateDate').val(RepDate);
			}
			//再赋值
			//感染类型
		    //var InfType =objInfo.split("^")[9].split(",")[0];
		    //$('#chkInfType'+InfType).radio('setValue', (InfType!="" ? true:false)); 
		         
		    //隔离方式
		    var InsulatType =objInfo.split("^")[12].split(",")[0];
		    $('#chkInsulatType'+InsulatType).radio('setValue', (InsulatType!="" ? true:false));     
   
	        //隔离措施赋值，可多选
			var ContactList =objInfo.split("^")[13]; 
			for (var len=0; len < ContactList.length;len++) {        
				var value = ContactList.split(',')[len];
				$('#chkContactList'+value).checkbox('setValue', (value!="" ? true:false));                
			}
			/*  
		    //飞沫隔离
		    var DropletList =objInfo.split("^")[14]; 
			for (var len=0; len < DropletList.length;len++) {        
				var value = DropletList.split(',')[len];
				$('#chkDropletList'+value).checkbox('setValue', (value!="" ? true:false));                
			}  
			*/
		    //感染病人安置
		    var PlaceList =objInfo.split("^")[15]; 
	        for (var len=0; len < PlaceList.length;len++) {        
				var value = PlaceList.split(',')[len];
				$('#chkPlaceList'+value).checkbox('setValue', (value!="" ? true:false));                
			}  
		    
		    //隔离单元安置
		    var UnitList =objInfo.split("^")[16]; 
	        for (var len=0; len < UnitList.length;len++) {        
				var value = UnitList.split(',')[len];
				$('#chkUnitList'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
			//隔离单元安置，其他
			$("#txtUnitExt").val(objInfo.split("^")[17])
		    
		    //感染病人诊疗 
		  	var TreatMent =objInfo.split("^")[18].split(",")[0];
		    $('#chkTreatMent'+TreatMent).radio('setValue', (TreatMent!="" ? true:false)); 
		     
		    //环境物表处理
		    var EnvMent =objInfo.split("^")[19].split(",")[0];
		    $('#chkEnvMent'+EnvMent).radio('setValue', (EnvMent!="" ? true:false)); 
		    
		    //用后被服处理
		    var ClothMent =objInfo.split("^")[20].split(",")[0];
		    $('#chkClothMent'+ClothMent).radio('setValue', (ClothMent!="" ? true:false)); 
		    
		    //探视者管理
		    var VisitList =objInfo.split("^")[21]; 
	        for (var len=0; len < VisitList.length;len++) {        
				var value = VisitList.split(',')[len];
				$('#chkVisitList'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
		    
		    //终末消毒  
		    var EndList =objInfo.split("^")[22]; 
	        for (var len=0; len < EndList.length;len++) {        
				var value = EndList.split(',')[len];
				$('#chkEndList'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
		
			$('#txtResume').val(objInfo.split("^")[23]);
			var Assess = objInfo.split("^")[27];
	        if (Assess) {
		        $HUI.radio("#Assess-"+Assess).setValue(true); // 评价
	        }	
	        $('#txtComments').val(objInfo.split("^")[28]);
	        
	        //易感因素  
		    var DoTS =objInfo.split("^")[29]; 
	        for (var len=0; len < DoTS.length;len++) {        
				var value = DoTS.split(',')[len];
				$('#chkDoTS'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
	            
		}
		obj.DisplayButtonStatus(RepStatus);
	}
	
	// 展示报告操作按钮
	obj.DisplayButtonStatus = function(RepStatus){
		if (!RepStatus) {
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
			$('#btnDelete').hide();
			$('#btnPrint').hide();
			$('#SumAssess').hide();
			$('#Comments').hide();
			$('#RepStatus').text("");
			$('#btnSaveTmp').show();
			$('#btnSaveRep').show();
		} else if (RepStatus == '1') {
			$('#btnSaveTmp').show();
			$('#btnSaveRep').show();
			$('#btnSaveRep').linkbutton({text:$g('提交')});
			$('#SumAssess').hide();
			$('#Comments').hide();
			$('#btnPrint').hide();
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
			$('#btnDelete').show();
			$('#RepStatus').text($g('保存'));
		}else if (RepStatus =='2') {		
			$('#btnSaveTmp').hide();
			$('#btnSaveRep').show();
			$('#btnSaveRep').linkbutton({text:$g('提交')});
			if (CheckFlg !='1') {
				$('#btnCheck').hide();				
			}else{
				$('#btnCheck').show();				
			}
			$('#btnUnCheck').hide();
			$('#btnPrint').show();
			$('#SumAssess').show();
			$('#Comments').show();			
			$('#RepStatus').text($g('提交'));
		} else if (RepStatus == '3') {
			$('#btnSaveRep').hide();
			$('#btnSaveTmp').hide();
			$('#btnCheck').hide();
            $('#btnUnCheck').show();
            if (CheckFlg !='1') {
                $('#btnDelete').hide();
                $('#btnUnCheck').hide();
            }
            
			$('#SumAssess').show();
			$('#Comments').show();
			$('#RepStatus').text($g('审核'));
		}else if (RepStatus =='4') {
			$('#SumAssess').hide();
			$('#Comments').hide();
			$('#btnSaveRep').show();
			$('#btnSaveRep').linkbutton({text:$g('重新提交')});
			$('#btnSaveTmp').hide();
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
			$('#btnDelete').hide();
			$('#btnPrint').hide();
			$('#RepStatus').text($g('删除'));
		}else if (RepStatus =='6') {
			$('#SumAssess').hide();
			$('#Comments').hide();
			$('#btnSaveRep').show();
			$('#btnSaveRep').linkbutton({text:$g('重新提交')});
			$('#btnSaveTmp').hide();
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
			$('#btnDelete').hide();
			$('#btnPrint').hide();
			$('#RepStatus').text($g("取消审核"));
		}
	}
	
	//保存（Status=1）//提交方法（Status=2）
	obj.SaveReport = function(Status, aFlg) {
        //单选多选框取值
        //var InfType=Common_RadioValue('chkInfType');	//感染类型
        var InsulatType=Common_RadioValue('chkInsulatType');       //隔离方式
        var ContactList=Common_CheckboxValue('chkContactList');	//隔离措施
        var DropletList='';  //飞沫隔离
        var PlaceList=Common_CheckboxValue('chkPlaceList');	//感染病人安置
        var UnitList=Common_CheckboxValue('chkUnitList');//隔离单元设置
        var TreatMent=Common_RadioValue('chkTreatMent');//感染病人诊疗
        var EnvMent=Common_RadioValue('chkEnvMent');//环境物表处理
        var ClothMent=Common_RadioValue('chkClothMent');//用后被服处理
        var VisitList=Common_CheckboxValue('chkVisitList');//探视者管理
        var EndList=Common_CheckboxValue('chkEndList');     //终末消毒
        var DoTS=Common_CheckboxValue('chkDoTS');     //易感因素
    	var UnitExt  = $("#txtUnitExt").val();	//其他隔离单元
        var Resume   = $("#txtResume").val();	//其他情况
        var Comments = $("#txtComments").val(); // add 20211116 批注
		var ErrorStr="";  
		var ID           = obj.MRBRepID;
		var AdmID        = EpisodeID;
		var LabRepDr     = LabRepID;
		var SubmissLocDr="",SpecimenDr="",SubmissDate="",BactDicDr="",BactDesc= "",MRBDicDr= "";LabResID="";	
		var rows = $('#gridApply').datagrid('getSelected');
		if (rows) {
			SubmissLocDr = rows.LocID;
			SpecimenDr   = rows.SpeID;
			SubmissDate  = rows.ActDate;
			BactDicDr    = rows.BacID;
			BactDesc     = rows.Bacteria;
			MRBDicDr     = rows.MRBID;
			LabRepDr     = rows.LabRepID;
			LabResID     = rows.LabResID;   //检验项目结果
		}else {
			 ErrorStr += ($g('先选中送检记录，再保存报告!')+'<br/>');
		}
		/*
		if (InfType=='') {
	        ErrorStr += '感染类型不允许为空!<br/>';
        }
        */
        if (InsulatType=='') {
	        ErrorStr += ($g('隔离方式不允许为空!')+'<br/>');
        }
        if (ContactList=='') {
	        ErrorStr += ($g('隔离措施不允许为空!')+'<br/>');
        }  
       if (ErrorStr != '') {
			$.messager.alert("提示",ErrorStr, 'info');
			return false;
		}
        //加强手卫生
        var HandHygiene="";
        //续发病例
        var SecondCase="";
        //审核报告总结性评价
		var RepAssess ="";
	    var AssessVal = $('#SumAssess input[name="Assess"]:checked').val();
	    if(AssessVal){
			RepAssess =AssessVal;
		}
		var IROutLabRepDr="";
		if (obj.MRBOutLabType=="外院携带"){
			var LabRepDr  = "";
			IROutLabRepDr = obj.ResultID;
		}
		var InputMBRStr = ID;
		InputMBRStr += "^" + AdmID;
		InputMBRStr += "^" + LabRepDr;
		InputMBRStr += "^" + SpecimenDr;
		InputMBRStr += "^" + SubmissDate;
		InputMBRStr += "^" + SubmissLocDr;
		InputMBRStr += "^" + BactDicDr;
		InputMBRStr += "^" + BactDesc;
		InputMBRStr += "^" + MRBDicDr;
		InputMBRStr += "^" + "";
		InputMBRStr += "^" + HandHygiene;
		InputMBRStr += "^" + SecondCase;
		InputMBRStr += "^" + InsulatType;
		InputMBRStr += "^" + ContactList;
		InputMBRStr += "^" + DropletList;
		InputMBRStr += "^" + PlaceList;
		InputMBRStr += "^" + UnitList;
		InputMBRStr += "^" + UnitExt;
		InputMBRStr += "^" + TreatMent;
		InputMBRStr += "^" + EnvMent;
		InputMBRStr += "^" + ClothMent;
		InputMBRStr += "^" + VisitList;
		InputMBRStr += "^" + EndList;
		InputMBRStr += "^" + Resume;
	    InputMBRStr += "^" + "";
	    InputMBRStr += "^" + "";
	    InputMBRStr += "^" + $.LOGON.USERID;
	    InputMBRStr += "^" + RepAssess;      //报告总结性评价
	    InputMBRStr += "^" + Comments;
	    InputMBRStr += "^" + IROutLabRepDr;
	    InputMBRStr += "^" + DoTS;
	    //报告信息
	   	var InputRepStr = "";         // 报告ID DHCHAI.IR.INFReport	
		InputRepStr += "^" + AdmID;
		InputRepStr += "^" + "5";
		InputRepStr += "^" + "";
		InputRepStr += "^" + "";
		InputRepStr += "^" + $.LOGON.LOCID;
		InputRepStr += "^" + $.LOGON.USERID; 
		InputRepStr += "^" + Status;
		
	    // 日志信息
	    var InputLogStr = "";            // DHCHAI.IR.INFReport
		InputLogStr += "^" + Status;     // 状态
	    InputLogStr += "^" + "";         // 操作意见
	    InputLogStr += "^" + $.LOGON.USERID;
	           
		var InputStr = InputMBRStr + "#" + InputRepStr + "#" + InputLogStr + "#" + aFlg;
		var retval = $cm ({
			ClassName:"DHCHAI.IRS.INFMBRSrv",
			MethodName:"SaveReport",
			ResultSetType:"array",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		obj.MRBRepID = retval;					
		return retval;
	}
	
	//加载按钮事件
	$('#btnSaveTmp').on("click", function(){	//保存
		var ret=obj.SaveReport("1"); 
		if (!ret) {    //update 20210708 防止错误提示后，报告ID赋值为空
			return;
		}else {
			if(parseInt(ret)>0){
				
				obj.MRBRepID = ret;
				var rows = $('#gridApply').datagrid('getSelected');
				if (!rows.MRBRepID) {
					var index = $("#gridApply").datagrid('getRowIndex', rows);
					$('#gridApply').datagrid('updateRow',{
						index: index,
						row: {
							MRBRepID: obj.MRBRepID
						}
					});
				}
				obj.ReportInfo(obj.ResultID,obj.MRBRepID);
				$.messager.alert("提示", "保存成功", 'info');
				return;	
			}else{
				obj.MRBRepID = '';
				if(parseInt(ret)=='-1') {
					$.messager.alert("提示",'多耐细菌报告内容保存失败!','info');
					return false;
				}else if (parseInt(ret)=='-2') {
					$.messager.alert("提示",'报告信息保存失败!','info');
					return false;
				}else if (parseInt(ret)=='-3') {
					$.messager.alert("提示",'报告日志信息保存失败!','info');
					return false;
				}
			}
		}
	});
	$('#btnSaveRep').on("click", function(){	//提交
	    var btnValue = document.getElementById("btnSaveRep").innerText;
	    if (btnValue=="重新提交") {
		    var ret=obj.SaveReport("2","1"); 
		   
	    } else {
		   var ret=obj.SaveReport("2");  
	    }	
		if(parseInt(ret)>0){
			obj.MRBRepID = ret;
			var rows = $('#gridApply').datagrid('getSelected');
			if (!rows.MRBRepID) {
				var index = $("#gridApply").datagrid('getRowIndex', rows);
				$('#gridApply').datagrid('updateRow',{
					index: index,
					row: {
						MRBRepID: obj.MRBRepID
					}
				});
			}
			obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			$.messager.alert("提示", "提交成功", 'info');
			return;	
		}else{
			obj.MRBRepID = '';
			if(parseInt(ret)=='-1') {
				$.messager.alert("提示",'多耐细菌报告内容提交失败!','info');
				return false;
			}else if (parseInt(ret)=='-2') {
				$.messager.alert("提示",'报告信息提交失败!','info');
				return false;
			}else if (parseInt(ret)=='-3') {
				$.messager.alert("提示",'报告日志信息提交失败!','info');
				return false;
			}
		}
	});
	$('#btnCheck').on("click", function(){	//审核
		var ret=obj.SaveReport("3"); 
		if(parseInt(ret)>0){
			obj.MRBRepID = ret;
			obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			$.messager.alert("提示", "审核成功", 'info');
			return;	
		}else{
			$.messager.alert("提示",'审核失败','info');
			return false;
		}	
	});
	$('#btnUnCheck').on("click", function(){	// 取消审核
		var ret=obj.SaveReport("6"); 
		if(parseInt(ret)>0){
			obj.MRBRepID = ret;
			var rows = $('#gridApply').datagrid('getSelected');
			if (!rows.MRBRepID) {
				var index = $("#gridApply").datagrid('getRowIndex', rows);
				$('#gridApply').datagrid('updateRow',{
					index: index,
					row: {
						MRBRepID: obj.MRBRepID
					}
				});
			}
			obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			$.messager.alert("提示", "取消审核成功", 'info');
			return;	
		}else{
			obj.MRBRepID = '';
			if(parseInt(ret)=='-1') {
				$.messager.alert("提示",'多耐细菌报告内容提交失败!','info');
				return false;
			}else if (parseInt(ret)=='-2') {
				$.messager.alert("提示",'报告信息提交失败!','info');
				return false;
			}else if (parseInt(ret)=='-3') {
				$.messager.alert("提示",'报告日志信息提交失败!','info');
				return false;
			}
		}
	});
	$('#btnDelete').on("click", function(){	//删除
		var ret=obj.SaveReport("4"); 
		if(parseInt(ret)>0){
			obj.MRBRepID = ret;
			obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			$.messager.alert("提示", "删除成功", 'info');
			return;	
		}else{
			$.messager.alert("提示",'删除失败','info');
			return false;
		}	
	});
	
	$('#btnPrint').on("click", function(){		//打印
		if (!obj.MRBRepID) return;
		//var fileName="{DHCHAI.INF.MBRReport.raq(aMRBRepID="+obj.MRBRepID+")}";
		//DHCCPM_RQDirectPrint(fileName);	
		var fileName="DHCHAI.INF.MBRReport.raq&aMRBRepID="+obj.MRBRepID;
		DHCCPM_RQPrint(fileName);
	});
	$('#btnClose').on("click", function(){		//关闭
		websys_showModal('close');
	});
	
	//加载检出菌表格
	obj.reloadgridApply = function(){
		$("#gridApply").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"QryMRBByEpsodeDr",
			ResultSetType:"array",
			aEpisodeDr:EpisodeID,
			page:1,
			rows:200
		},function(rs){
			$('#gridApply').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	
	obj.MenuEdit = function(index,ResultID,MRBOutLabType,RowID) {
		var e = event || window.event;
		$('#gridApply').datagrid("clearSelections"); //取消所有选中项 
		$('#gridApply').datagrid("selectRow", index); //根据索引选中该行 
		$('#menu').menu({
		    onClick:function(item){
		       	if (MRBOutLabType=="外院携带"){
				   var ret = $m({
						ClassName:"DHCHAI.IR.OutLabReport",
						MethodName:"UpdateInfType",
						aID:RowID,
						aMakeInfType:item.id
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert("错误提示", "标记失败!Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: '标记成功！',type:'success',timeout: 1000});
						obj.reloadgridApply(); //刷新当前页
					}
				}else{
			       	var ret = $m({
						ClassName:"DHCHAI.DP.LabVisitRepResult",
						MethodName:"UpdateInfType",
						aID:ResultID,
						aMakeInfType:item.id,
						aIsByHand:1
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert("错误提示", "标记失败!Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: '标记成功！',type:'success',timeout: 1000});
						obj.reloadgridApply(); //刷新当前页
					}
				}
		    }
		});
		$('#menu').menu('show', { 
			left: e.pageX,   //在鼠标点击处显示菜单 
			top: e.pageY
		});
	}
	
}