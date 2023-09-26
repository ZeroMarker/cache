//页面Event
function InitWinEvent(obj){
	obj.SCode="";
	window.returnValue=false;
	obj.LoadEvent=function(){
			//参考内容初始化↓
			obj.InitMrButtons(MrListID);
		}
	$('#winConfirmInfo').dialog({
		title: '',
		iconCls:"icon-edit",
		closed: true,
		modal: true,
		isTopZindex:true	
	});
	$('#winVal').dialog({
		closed: true,
		closable:false,
		isTopZindex:true,
		modal: true,
		width:document.documentElement.clientWidth-20,
		height:document.documentElement.clientHeight-20,
		onClose:function(){
			$('#ValHtml').remove();
			obj.endEditing();
			},
		buttons:[{
				text:'确认',
				handler:function(){
					obj.CalcValue();
					$HUI.dialog('#winVal').close();
				}},
				{
				text:'退出',
				handler:function(){
					$HUI.dialog('#winVal').close();
				}}
			]	
		
	});
	obj.ChangeRowEditor=function(Value,Code) {  //通过主项的值决定关联了子项目的显示格式及是否可编辑
		
		//根据该项目Code获取被关联项目的展现/隐藏属性
		var relativeCode=$m({
			ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
			MethodName:"GetRelativeItemCode",
			aCode:Code
		},false)
		var RCodeArr=relativeCode.split('^')
		RCodeStr="",RValueStr=""
		for (var i=0;i<RCodeArr.length;i++){
			var RCodei=RCodeArr[i]
			if (RCodei=="") continue;
			var rowIndex=$('#gridQCFormShow').datagrid('getRowIndex',RCodei);
			var row=$('#gridQCFormShow').datagrid('getRows')[rowIndex]
			var RValuei=row.ExecResult
			if (RValuei=='undefined') RValuei="";
			if (("^"+RCodeStr+"^").indexOf("^"+RCodei+"^")>0) continue;
			RCodeStr=RCodeStr+"^"+RCodei
			if (Code==RCodei) {RValueStr=RValueStr+"^"+Value}
			else{ RValueStr=RValueStr+"^"+RValuei}
		}
		$m({
			ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
			MethodName:"GetSubItemMsgNew",
			aValueStr:RValueStr,
			aCodeStr:RCodeStr
			},function(data){
				var LinkSubItemCodeArr=data.split('`')
				for (var CodeIndex=0;CodeIndex<LinkSubItemCodeArr.length;CodeIndex++) {
					var EditPower=LinkSubItemCodeArr[CodeIndex].split('^')[0]
					var ItemCode=LinkSubItemCodeArr[CodeIndex].split('^')[1]
					if (ItemCode==undefined) return; 
					var rowIndex=$('#gridQCFormShow').datagrid('getRowIndex',ItemCode);
					var row=$('#gridQCFormShow').datagrid('getRows')[rowIndex]
					if (!row) continue;
					if ((row.BTDesc.indexOf("可选")>0)||(EditPower=='0')) BTIsNeeded="否"
					if (EditPower!=row.EditPower) {
						$("#gridQCFormShow").datagrid("updateRow",{  
		                   index:rowIndex, //行索引  
		                   row:{  
			                   EditPower:EditPower, //编辑权限
			                   ExecResult:""
		                   }  
		            	});
					}
				}
			})
			
		}
		$('#btnSaveInfo').on('click',function() {
			obj.endEditing();
			var ret=obj.Validata('Submit')
			if (ret) {
					obj.SaveReport('Submit')
			}else{
					return;
				}	
		});	
		$('#btnSaveTmpInfo').on('click',function(){
			obj.endEditing();
			var ret=obj.Validata('Save')
			if (ret) {	
				obj.SaveReport('Save');
			}else{
					return;
				}
		});		
		obj.SaveReport=function(SCode){
			obj.endEditing();
			var Err=""
			var rows=$('#gridQCFormShow').datagrid('getChanges')

			for (var i=0;i<rows.length;i++) {
				var tmprow=rows[i]
				var ParrefID=MrListID
				var ItemDr=tmprow.BTID
				var Value=tmprow.ExecResult
				var UserID=session['LOGON.USERID']
				var InputStr=ParrefID+"^"+ItemDr+"^"+Value+"^"+UserID
				var flg=$m({
					ClassName:"DHCMA.CPW.SD.QCItemExec",
					MethodName:"Update",
					aInputStr:InputStr
					},false)
				if (parseInt(flg)<1) {
					Err=Err+"第"+(i+1)+"行数据保存错误.<br>"
					}
			}
			if (Err!="") {
				$.messager.alert("错误提示", "数据保存错误!Error=" + Err, 'info');
				}else{
					$.messager.popover({msg: '操作成功！',type:'success',timeout: 1000})
					var title  = top.$('#CurrStatus')[0].innerText;
					title = title.substr(0,title.indexOf("报告状态")+5);
					if (SCode=="Save") {
						top.$('#CurrStatus').text(title+"保存");	
					} else {
						top.$('#CurrStatus').text(title+"提交");	
					}
					//增加状态操作记录
					var StateStr=MrListID+"^"+SCode+"^"+session['LOGON.USERID']
					var ErrInfo=$m({
							ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
							MethodName:"ChangeMrlistSatus",
							aInput:StateStr
						},false)
					if (ErrInfo){
						$.messager.alert("错误提示", "状态更新错误!Error=" + ErrInfo, 'info');
						}
					
					$('#gridQCFormShow').datagrid('reload');
					window.returnValue=true;
					obj.InitMrButtons(MrListID);
					}
	
		}
	$('#btnCheckRep').on('click',function(){obj.ChangeMrStat('Check')});
	$('#btnUpInfo').on('click',function(){
		var UpRet=$m({
			ClassName:'DHCMA.CPW.SDS.QCInterface',
			MethodName:'Upload',
			aMRListID:MrListID	
		},false)
		if (parseInt(UpRet)==1) {
				$.messager.popover({msg: SDesc+'上传成功！',type:'success',timeout: 1000})
				//改变表单状态
				var StateStr=MrListID+"^Up^"+session['LOGON.USERID']
				ErrInfo=$m({
							ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
							MethodName:"ChangeMrlistSatus",
							aInput:StateStr
					},false)
				obj.InitMrButtons(MrListID);
			}else if(UpRet.indexOf('病案号重复')>0){	
				//改变表单状态
				var StateStr=MrListID+"^Up^"+session['LOGON.USERID']
				ErrInfo=$m({
							ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
							MethodName:"ChangeMrlistSatus",
							aInput:StateStr
					},false)
				if (ErrInfo){
						$.messager.popover({msg: '已存在上传记录，更新上传状态错误'+ErrInfo+'！',type:'success',timeout: 3000})
					}else{
						$.messager.popover({msg: '已存在上传记录，更新上传状态成功！',type:'success',timeout: 3000})
						//刷新列表
						$('#gridQCMrList').datagrid('reload');
				}
				
			}else{
				$.messager.alert("错误提示", "表单上传失败!Error=" + UpRet, 'info');
			}
		
		});
	$('#btnOutSD').on('click',function(){obj.ChangeMrStat('O')});
	$('#btnBackSD').on('click',function() {
			obj.ChangeMrStat('Back');	
		});
	obj.ChangeMrStat=function(SCode){
		if (SCode=="") return;
		var ErrInfo="";
		var SDesc=(SCode=="Check"?"审核":SCode=="Up"?"上传":SCode=="O"?"排除":SCode=="Back"?"退回":1)
		$.messager.confirm("提示", "是否"+SDesc+"这份病例?", function (r) {				
			if (r) {
						if (SCode=="O") {
							var QCID=$m({
								ClassName:"DHCMA.CPW.SDS.QCMrListSrv",
								MethodName:"GetQCIDByMrListID",
								aMrListID:MrListID
								},false)
							if (parseInt(QCID)<1) {$.messager.alert("错误提示", "未获取到病种信息", 'info');return;}
							//弹窗选择取消确认理由，或填写备注	
							Common_CheckboxToSDRule("RuleDic",QCID,2,1);	
							$('#winConfirmInfo').dialog({
								title: '排除单病种【信息录入】',
								height: 450 
							})
							obj.SCode=SCode
							$HUI.dialog('#winConfirmInfo').open();
							}else if(SCode=="Back"){
								//退回报告需要填写退回原因
								$.messager.prompt("提示", "请输入退回原因：", function (r) {
									if (r) {
										var StateStr=MrListID+"^"+SCode+"^"+session['LOGON.USERID']+"^^"+r;
										ErrInfo=$m({
											ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
											MethodName:"ChangeMrlistSatus",
											aInput:StateStr
										},false)
										$.messager.popover({msg: SDesc+'操作成功！',type:'success',timeout: 1000});
	
										var title  = top.$('#CurrStatus')[0].innerText;
										title = title.substr(0,title.indexOf("报告状态")+5);
            							top.$('#CurrStatus').text(title+SDesc);
										window.returnValue=true;
										obj.InitMrButtons(MrListID);
									} else {
										$.messager.popover({msg:"请撤销了退回操作！",type:'info'});
									}
								});
							}else{
									
									var StateStr=MrListID+"^"+SCode+"^"+session['LOGON.USERID']
									ErrInfo=$m({
										ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
										MethodName:"ChangeMrlistSatus",
										aInput:StateStr
								},false)
								if (ErrInfo){
										$.messager.alert("错误提示", "状态更新错误!Error=" + ErrInfo, 'info');
									}else{
										$.messager.popover({msg: SDesc+'操作成功！',type:'success',timeout: 1000})
									
										var title  = top.$('#CurrStatus')[0].innerText;
										title = title.substr(0,title.indexOf("报告状态")+5);
            							top.$('#CurrStatus').text(title+SDesc);
										window.returnValue=true;
										obj.InitMrButtons(MrListID);
										}
							}
						
			}})
		}
	$('#SaveRule').on('click',function () {
		var RuleStr=Common_CheckboxValue('RuleDic')
		var Resume=$('#RuleResume').val()
		var RuleInputStr=MrListID+"^"+obj.SCode+"^"+session['LOGON.USERID']+"^"+RuleStr+"^"+Resume
		var flg = $m({
			ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
			MethodName:"ChangeMrlistSatus",
			aInput:RuleInputStr
		},false);
		if (parseInt(flg) < 0) {
			$.messager.alert("错误提示","操作失败!Error=" + flg, 'info');	
		} else {
			$.messager.popover({msg: '操作成功！',type:'success',timeout: 1000});
		
			var title  = top.$('#CurrStatus')[0].innerText;
			title = title.substr(0,title.indexOf("报告状态")+5);
            top.$('#CurrStatus').text(title+"排除");
			window.returnValue=true;
			obj.InitMrButtons(MrListID);
			
		}
		$HUI.dialog('#winConfirmInfo').close();
	})
	$('#CanCelRule').on('click',function(){$HUI.dialog('#winConfirmInfo').close();})
	obj.Validata=function(aType){
		var rows=$('#gridQCFormShow').datagrid('getRows')
		var Itemstr = "";
		var num = 0;
		var ErrorInfo=""
		for (var i=0;i<rows.length;i++){
			var tmprow = rows[i];
			var ItemValue = tmprow.ExecResult;
			var ItemBTIsNeeded = tmprow.BTIsNeeded;
			var ItemBTDesc = tmprow.BTDesc
			var WarningInfo = tmprow.ExecWarning
			if((aType=="Submit")&&(ItemValue=="")&&(ItemBTIsNeeded=="是")&&(tmprow.EditPower=='1')){
				var Itemstr=Itemstr+"^"+ItemBTDesc
				num=num+1;
			}
			
			if (WarningInfo!=""){
				ErrorInfo=ErrorInfo+ItemBTDesc+":"+WarningInfo+"<hr/>"
			}
			
		}
		if (num>0) ErrorInfo=ErrorInfo+'该表单有'+num+'项必填项未填!<br/>';
		if(ErrorInfo!=""){
			$.messager.alert("错误提示",ErrorInfo,'error')
			return false;
		}
		else {return true;}
		}
		
	obj.InitMrButtons=function(MrListID){
			$m({
				//DHCMA.CPW.SDS.QCMrListStateSrv).GetCurrStat
				ClassName:'DHCMA.CPW.SDS.QCMrListStateSrv',
				MethodName:'GetCurrStat',
				MrListID:MrListID
			},function(StatCode){
				if (StatCode=="") StatCode="I";
				switch(StatCode) {
				case 'Submit':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').show();
					$('#btnCheckRep').show();
					$('#btnBackSD').show();
					$('#btnUpInfo').hide();
					$('#btnOutSD').show();
					$('#btnPrint').show();
					break;
				case 'Save':
					$('#btnSaveTmpInfo').show();
					$('#btnSaveInfo').show();
					$('#btnCheckRep').hide();
					$('#btnBackSD').show();
					$('#btnUpInfo').hide();
					$('#btnOutSD').show();
					$('#btnPrint').hide();
					break;
				case 'Back':
					$('#btnSaveTmpInfo').show();
					$('#btnSaveInfo').show();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnUpInfo').hide();
					$('#btnOutSD').show();
					$('#btnPrint').hide();
					break;
				case 'I':
					$('#btnSaveTmpInfo').show();
					$('#btnSaveInfo').show();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnUpInfo').hide();
					$('#btnOutSD').show();
					$('#btnPrint').hide();
					break;
				case 'O':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').hide();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnUpInfo').hide();
					$('#btnOutSD').hide();
					$('#btnPrint').hide();
					break;
				case 'E':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').hide();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnUpInfo').hide();
					$('#btnOutSD').hide();
					$('#btnPrint').hide();
					break;
				case 'Check':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').hide();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnOutSD').hide();
					$('#btnUpInfo').show();
					$('#btnPrint').show();
					break;
				case 'Up':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').hide();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnOutSD').hide();
					$('#btnUpInfo').hide();
					$('#btnPrint').show();
					break;
				default:
					break;
				}
				if ((tDHCMedMenuOper['LocAdmin']!=1)&&(tDHCMedMenuOper['HosAdmin']!=1)&&(tDHCMedMenuOper['admin']!=1))
				{
					//如果新旧系统都没有授权管理员，用户无审核权限
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();	
				}
			})		
	}	
	$('#btnPrint').on('click',function(){
		//$('#gridQCFormShow').datagrid('toExcel','单病种表单.xls');
		debugger;	
		var fileName="{DHCMAFormShow.raq(MrListID="+MrListID+")}";
		debugger;
		DHCCPM_RQDirectPrint(fileName);
	});
	obj.CalcValue=function(){
	var checkList = document.getElementsByTagName("input"), chkCount = 0;
	for (var i=0; i<checkList.length; i++) {
		if (checkList[i].checked) {
			chkCount = chkCount + parseInt(checkList[i].value);
		}
	}
	var ed = $('#gridQCFormShow').datagrid('getEditor', {index:editIndex,field:'ExecResult'});
	$(ed.target).val(chkCount);
}
	
}
HISUIHtml =function(){
	$HUI.checkbox("input.dic-check",{})
	$HUI.radio("input.dic-radio",{})
	}
function Unhtml(strDicList,o,n) {
	var reg=new RegExp(o,'g')
	return strDicList.replace(reg,n)
}

function ValiItem(rd){
	var WarningInfo="",ParamArr=""
	var edValus=rd.ExecResult
	if(rd.BTExpressParam!="") ParamArr=rd.BTExpressParam.split(',')
	var ParamLen=ParamArr.length
	if (ParamLen>0) {
		if (rd.BTTypeCode.indexOf('Combo')>-1) {
			for (var i=0;i<ParamLen;i++){
			 	var Parami=ParamArr[i]
			 	if (Parami.indexOf("MINLEN")>-1) {
			 		target=Parami.split(':')[1]
			 		if ((target)&&(edValus.length<target)) {
				 		WarningInfo=WarningInfo+"该项目最少需要选择【"+target+"】项<br>"
				 	}
				 }
				if (Parami.indexOf("Needed")>-1) {
					target=Parami.split(':')[1]
					if ((target)&&(edValus.indexOf(target)<0)) {
						WarningInfo=WarningInfo+"该项目必须要有【"+target+"】值<br>";
					}
				}
			}
		}else if(rd.BTTypeCode=='Text') {
			 for (var i=0;i<ParamLen;i++){
			 	var Parami=ParamArr[i]
			 	if (Parami.indexOf("MAXLEN")>-1) {
			 		target=Parami.split(':')[1]
			 		if (edValus.length>target) {
				 		WarningInfo=WarningInfo+"该项目最大字符串长度为【"+target+"】<br>"
				 	}
				}
			}
		}else if(rd.BTTypeCode=='Num'){
			 for (var i=0;i<ParamLen;i++){
				 	var Parami=ParamArr[i]
					if (Parami.indexOf("MAXVAL")>-1) {
						target=Parami.split(':')[1]
						//alert(parseInt(edValus)>parseInt(target));
						if ((target)&&(parseInt(edValus)>parseInt(target))) {
								WarningInfo=WarningInfo+"该数值不能大于【"+target+"】<br>";

							}
					}
				 }
		}else if(rd.BTTypeCode.indexOf("Date")>-1){
			 for (var i=0;i<ParamLen;i++){
			 	var Parami=ParamArr[i]
				if (Parami.indexOf("CPDATE")>-1) {
					ExpLogic=Parami.split(":")[1]
					var CpName="",targetName="",DateChangFlg=0
					if (edValus.indexOf('/')>0) DateChangFlg=1;
					if (ExpLogic.indexOf('Now')>-1) {
						targetName="当前日期",CpName="大于",targetValue=Common_GetCurrDateTime(new Date())
					}else{
						if (ExpLogic.split('|')[0].indexOf('-')>-1) TmpCode=ExpLogic.split('|')[0],CpName="大于"
						else TmpCode=ExpLogic.split('|')[1],CpName="小于"
						targetName=$m({
							ClassName:'DHCMA.CPW.SDS.QCEntityItemSrv',
							MethodName:'getItemDescByCode',
							ItemCode:TmpCode
						},false)
						var rowIndex=$('#gridQCFormShow').datagrid('getRowIndex',TmpCode);
						if (rowIndex<0) {
							WarningInfo=WarningInfo+"该项目的校验表达式无法正常识别<br>";
							continue;	
							}
						var row=$('#gridQCFormShow').datagrid('getRows')[rowIndex]
						var targetValue=row.ExecResult
						var targetValueTmp=targetValue
						if (DateChangFlg=1) targetValueTmp=Common_Format13DateT(targetValue)
						ExpLogic=ExpLogic.replace(TmpCode,targetValueTmp);
					}
					var NowDateT=Common_GetCurrDateTime(new Date())
					if (DateChangFlg=1) NowDateT=Common_Format13DateT(NowDateT)
					var edValusTmp=edValus
					if (DateChangFlg=1) edValusTmp=Common_Format13DateT(edValus)
					ExpLogic=ExpLogic.replace('Now',NowDateT);
					ExpLogic=ExpLogic.replace('this',edValusTmp);
					if ((ExpLogic.split('|')[0]=="")||(ExpLogic.split('|')[1]=="")) continue;
					var LogicRet=ExpLogic.split('|')[0]>ExpLogic.split('|')[1];
					if (!LogicRet){
						WarningInfo=WarningInfo+"该日期不能"+CpName+targetName+"【"+targetValue+"】<br>";	
					}
				}
			}
		}
	}else{	
		if (rd.ExecResult=="") return ""; //如果当前项目值为空，则放弃该条校验
		var RuleItemCodeStr=$m({
			ClassName:"DHCMA.CPW.SDS.QCItemValidRuleSrv",
			MethodName:"GetRuleItemCode",
			aItemCode:rd.BTCode
		},false)
		var RCodeArr=RuleItemCodeStr.split('^')
		RValueStr=""
		for (var i=0;i<RCodeArr.length;i++){
			var RCodei=RCodeArr[i]
			if (RCodei=="") continue;
			var rowIndex=$('#gridQCFormShow').datagrid('getRowIndex',RCodei);
			var row=$('#gridQCFormShow').datagrid('getRows')[rowIndex]
			var RValuei=row.ExecResult
			if (i==0) {
				RValueStr=RValuei
			}else {RValueStr=RValueStr+"^"+RValuei}
		}
		var WarningInfo=$m({
			ClassName:"DHCMA.CPW.SDS.QCItemValidRuleSrv",
			MethodName:"GetValiMsg",
			aItemCode:rd.BTCode,
			aItemValue:rd.ExecResult,
			aItemCodeStr:RuleItemCodeStr,
			aItemValStr:RValueStr
		},false)
		WarningArr=WarningInfo.split('&');
		for (var i=0;i<WarningArr.length;i++){
			var xvalue=WarningArr[i]
			var RuleType=xvalue.split('^')[1]
			var value=xvalue.split('^')[0]
			if (RuleType=='stop') {
				$.messager.confirm("提示", value+",是否退出并排除这份病例?", function (r) {	
					if (r) {
						websys_showModal('close')
					}	
				})			
			}
		}
	}
	return WarningInfo
}