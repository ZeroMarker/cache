//页面Event
function InitWinEvent(obj){
	obj.SCode="";
	HideRowStr=""
	window.returnValue=false;
	obj.LoadEvent=function(){
			//参考内容初始化↓
			obj.InitMrButtons(MrListID);
			//根据表单内容判断是否存在历史表单,存在返回历史表单版本
			$m({
				ClassName:'DHCMA.CPW.SDS.QCMrListSrv',
				MethodName:'GetOldFormVer',
				aMrListID:MrListID	
			},function(ret){
				if 	(ret){
					$('#ViewOldForm').css('display','');
					$('#ViewOldForm').on('click',function(){
							obj.OpenOldForm(ret);
					});
				}
			})
			var AdmStr=$m({
				ClassName:'DHCMA.CPW.SDS.QCMrListSrv',
				MethodName:'GetAdmInfoByMrListID',
				aMrListID:MrListID	
			},false)
			$('#btnEMR').on('click',function(){
				obj.DisplayEPRView(AdmStr.split('^')[0],AdmStr.split('^')[1]);
				});
		}
	obj.OpenOldForm=function(VerID){
			obj.gridQCFormShowVer = $HUI.datagrid("#gridQCFormShowVer",{
			fit:true,
			title:title,
			iconCls:"icon-template",
			toolbar:'#custtb',
			headerCls:'panel-header-gray',
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			singleSelect: true,
			//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			autoRowHeight: false,
			rownumbers:true, 
			loadMsg:'数据加载中...',
		    url:$URL,
		    nowrap:false,
		    bodyCls:'no-border',
		    queryParams:{
			    ClassName:"DHCMA.CPW.SDS.QCItemExecSrv",
				QueryName:"QryQCItemExec",
				  MrListID:MrListID,
				  aQCEntityID:obj.QCID,
				  aVerID:VerID,	
			   	   rows:10000
		    },
			idField:'BTCode',
			columns:[[
				{field:'BTDesc',title:'描述',width:'420',sortable:true,align:'left',
					styler: function(value,row,index){
						return "text-align:left;background-color:#F6F6F6;border:1px solid #E3E3E3;"
					}
				},
				{field:'BTItemCatDesc',title:'项目分类',width:'150',hidden:true},
				{field:'ExecResult',title:'结果值<span style="color:red">(选中行录入项目结果)<span>',width:'550',sortable:false,
					styler: function(value,row,index){
						return "text-align:left;border:1px solid #E3E3E3"
					},
					formatter: function(value,row,index){
						if(value==""){
							return '<span style="color:#AEA6A8;">'+row.Resume+'</span>';
						}else {
							if (row.BTTypeDesc.indexOf('字典')>-1){
								return '<span style="color:#1474AF;">'+row.ExecResultText+'</span>';
							}else{
								return '<span style="color:#1474AF;">'+value+'</span>';
								}
						}
					}
				}
			]],
			groupField:'BTItemCat',
			view:groupview,
			groupFormatter:function(value, rows){
				return '<span style="font-size:16px">'+value+'</span>' ;
		        }, 
			rowStyler:function(index,row){  
		       if (row.EditPower==0){                //通过判断行的某个属性值 ，给row加载单独的样式
		           	return 'display:none';    
		       }else {
			       	return '';
			       }    
	   		} 
		})
		$HUI.dialog('#winOldForm').open()
	}
	$('#winOldForm').window({
		fit:'true',
	    modal:false,
	    closed: true,
	    minimizable:false,
	    maximizable:false,
	    title:$g('历史表单'),
	    href:''
	});
	$('#winConfirmInfo').dialog({
		title: '',
		iconCls:"icon-w-edit",
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
				text:$g('计算分值'),
				handler:function(){
					obj.CalcValue();
					$HUI.dialog('#winVal').close();
				}},
				{
				text:'退出评估',
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
			aCode:Code,
			aQCID:obj.QCID,
			aVerID:obj.VerID
		},false)
		var RCodeArr=relativeCode.split('^')
		RCodeStr="",RValueStr=""
		for (var i=0;i<RCodeArr.length;i++){
			var RCodei=RCodeArr[i]
			if (RCodei=="") continue;
			var rowIndex=$('#gridQCFormShow').datagrid('getRowIndex',RCodei);
			var row=$('#gridQCFormShow').datagrid('getRows')[rowIndex]
			if((typeof(row)=='undefined')||(row.EditPower=="0")) {
				var RValuei=""
			}else{
				var RValuei=row.ExecResult
			}
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
			aCodeStr:RCodeStr,
			aQCID:obj.QCID,
			aVerID:obj.VerID
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
			                   ExecResult:"",
			                   ExecWarning:""
		                   }  
		            	});
		            	//将隐藏的项目记录起来，保存的时候清空，否则会影响相关联项目的显隐判断（TC-5-1-2）
		            	if ((EditPower=="0")&&(HideRowStr.indexOf("^"+ItemCode+"^")<0)) {
			            	HideRowStr=HideRowStr+"^"+ItemCode+"^"
			            }
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
					Err=Err+$g("数据保存错误")+":"+$g("行号")+'-'+(i+1)+".<br>"
					}
			}
			var HideRowArr=HideRowStr.split('^')
		  	for (var j=0;j<HideRowArr.length;j++){
				var jItemCode=HideRowArr[j]
				if (jItemCode=="") continue;
				var rowIndex=$('#gridQCFormShow').datagrid('getRowIndex',jItemCode);
				var tmprow=$('#gridQCFormShow').datagrid('getRows')[rowIndex]
				if (tmprow.EditPower!="0") continue;
				var ParrefID=MrListID
				var ItemDr=tmprow.BTID
				var Value=""
				var UserID=session['LOGON.USERID']
				var InputStr=ParrefID+"^"+ItemDr+"^"+Value+"^"+UserID
				var flg=$m({
					ClassName:"DHCMA.CPW.SD.QCItemExec",
					MethodName:"Update",
					aInputStr:InputStr
					},false)
				if (parseInt(flg)<1) {
					Err=Err+$g("数据保存错误")+":"+$g("行号")+'-'+(rowIndex+1)+".<br>"
					}
			}
			if (Err!="") {
				$.messager.alert($g("错误提示"), $g("数据保存错误")+":"+ Err, 'info');
				}else{
					$.messager.popover({msg: $g('操作成功'),type:'success',timeout: 1000})
					var title  = top.$('#CurrStatus')[0].innerText;
					title = title.substr(0,title.indexOf($g("报告状态"))+5);
					if (SCode=="Save") {
						top.$('#CurrStatus').text(title+$g("保存"));	
					} else {
						top.$('#CurrStatus').text(title+$g("提交"));	
					}
					//增加状态操作记录
					var StateStr=MrListID+"^"+SCode+"^"+session['LOGON.USERID']
					var ErrInfo=$m({
							ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
							MethodName:"ChangeMrlistSatus",
							aInput:StateStr
						},false)
					if (ErrInfo){
						$.messager.alert($g("错误提示"), $g("状态更新错误")+":" + ErrInfo, 'info');
						}
					
					$('#gridQCFormShow').datagrid('reload');
					//记录下最新的评分表内容
					for(edIndex in ScoreArr) { 
						for(v in ScoreArr[edIndex]) { 
							var DicStr=""
							for(var j=0;j<ScoreArr[edIndex][v].length;j++) {
								var DicCode=ScoreArr[edIndex][v][j]
								if (DicStr=="") DicStr=DicCode
								else DicStr=DicStr+","+DicCode
							} 
							var ScoreStr=MrListID+"^"+v+"^"+DicStr
							$m({
								ClassName:"DHCMA.CPW.SDS.QCMrListScoreSrv",
								MethodName:"saveScoreRec",
								aInput:ScoreStr,
								aQCID:obj.QCID,
								aVerID:obj.VerID
							},false)
							console.log(v,ScoreStr)
						}	
					} 
					window.returnValue=true;
					obj.InitMrButtons(MrListID);
				}
	
		}
	$('#btnCheckRep').on('click',function(){
		var CheckDesc=$('#btnCheckRep').linkbutton("options").text
		//根据按钮描述，采取审核/取消审核操作
		if (CheckDesc==$g("取消审核")){
			var CheckCode="Submit"
		}else{
			var CheckCode="Check"
		}
		obj.ChangeMrStat(CheckCode)
	});
	$('#btnUpInfo').on('click',function(){
		$.messager.progress({
				title: $g("提示"),
				msg: $g('正在上传数据'),
				text: $g('上传中')+'....'
		});
		$m({
		ClassName:'DHCMA.CPW.SDS.QCInterface',
		MethodName:'Upload',
		aMRListID:MrListID	
		},function(UpRet){
			$.messager.progress("close")
			var UpRetArr=UpRet.split('^')
			if (UpRetArr[0]==1) {
					var msginfo=$g("已正式上传至国家平台"),statusDesc=$g("正式上传"),statusCode="Up"
					if (UpRetArr[1]=="") {
						var msginfo=$g("测试上传成功，请联系信息中心正式对接平台");
						var statusCode="tUp";
						var statusDesc=$g("测试上传");
					}
					$.messager.popover({msg: msginfo,type:'success',timeout: 1000})
					//改变表单状态
					var StateStr=MrListID+"^"+statusCode+"^"+session['LOGON.USERID']
					ErrInfo=$m({
								ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
								MethodName:"ChangeMrlistSatus",
								aInput:StateStr
						},false)
					var title  = top.$('#CurrStatus')[0].innerText;
					title = title.substr(0,title.indexOf($g("报告状态"))+5);
					top.$('#CurrStatus').text(title+statusDesc);
					obj.InitMrButtons(MrListID);
				}else if(UpRet.indexOf('重复')>0){	
					//改变表单状态
					var StateStr=MrListID+"^Up^"+session['LOGON.USERID']
					ErrInfo=$m({
								ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
								MethodName:"ChangeMrlistSatus",
								aInput:StateStr
						},false)
					if (ErrInfo){
							$.messager.popover({msg: $g('已存在上传记录，更新上传状态错误')+ErrInfo+'！',type:'success',timeout: 3000})
						}else{
							$.messager.popover({msg: $g('已存在上传记录，更新上传状态成功'),type:'success',timeout: 3000})
							//刷新列表
							$('#gridQCMrList').datagrid('reload');
					}
					
				}else{
					$.messager.alert($g("错误提示"), $g("表单上传失败")+":" + UpRet, 'info');
				}		
		});
	});

	$('#btnOutSD').on('click',function(){obj.ChangeMrStat('O')});
	$('#btnBackSD').on('click',function() {
			obj.ChangeMrStat('Back');	
		});
	obj.ChangeMrStat=function(SCode){
		if (SCode=="") return;
		var ErrInfo="";
		var SDesc=(SCode=="Check"?$g("审核"):SCode=="Submit"?$g("取消审核"):SCode=="Up"?$g("上传"):SCode=="O"?$g("排除"):SCode=="Back"?$g("退回"):1)
		$.messager.confirm("提示", "是否"+SDesc+"这份病例?", function (r) {				
			if (r) {
						if (SCode=="O") {
							var QCID=$m({
								ClassName:"DHCMA.CPW.SDS.QCMrListSrv",
								MethodName:"GetQCIDByMrListID",
								aMrListID:MrListID
								},false)
							if (parseInt(QCID)<1) {$.messager.alert($g("错误提示"), $g("未获取到病种信息"), 'info');return;}
							//弹窗选择取消确认理由，或填写备注	
							Common_CheckboxToSDRule("RuleDic",QCID,2,1);	
							$('#winConfirmInfo').dialog({
								title: $g('排除单病种'),
								height: 450 
							})
							obj.SCode=SCode
							$HUI.dialog('#winConfirmInfo').open();
							}else if(SCode=="Back"){
								//退回报告需要填写退回原因
								$.messager.prompt($g("提示"), $g("请输入退回原因"), function (r) {
									if (r) {
										var StateStr=MrListID+"^"+SCode+"^"+session['LOGON.USERID']+"^^"+r;
										ErrInfo=$m({
											ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
											MethodName:"ChangeMrlistSatus",
											aInput:StateStr
										},false)
										$.messager.popover({msg: SDesc+$g('操作成功'),type:'success',timeout: 1000});
	
										var title  = top.$('#CurrStatus')[0].innerText;
										title = title.substr(0,title.indexOf($g("报告状态"))+5);
            							top.$('#CurrStatus').text(title+SDesc);
										window.returnValue=true;
										obj.InitMrButtons(MrListID);
									} else if(r==""){
										$.messager.popover({msg:$g("请输入退回原因"),type:'info'});
										return
									}
									else {
										$.messager.popover({msg:$g("撤销了退回操作"),type:'info'});
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
										$.messager.alert($g("错误提示"), $g("状态更新错误")+":" + ErrInfo, 'info');
									}else{
										$.messager.popover({msg: SDesc+$g('操作成功'),type:'success',timeout: 1000})
									
										var title  = top.$('#CurrStatus')[0].innerText;
										title = title.substr(0,title.indexOf($g("报告状态"))+5);
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
		if ((!RuleStr)&&(Resume=="")){
			$.messager.alert($g("错误提示"),$g("依据原因和其他备注不能都为空"), 'info');	
			return
			}
		var RuleInputStr=MrListID+"^"+obj.SCode+"^"+session['LOGON.USERID']+"^"+RuleStr+"^"+Resume
		var flg = $m({
			ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
			MethodName:"ChangeMrlistSatus",
			aInput:RuleInputStr
		},false);
		if (parseInt(flg) < 0) {
			$.messager.alert($g("错误提示"),$g("操作失败")+":" + flg, 'info');	
		} else {
			$.messager.popover({msg: $g('操作成功')+'！',type:'success',timeout: 1000});
		
			var title  = top.$('#CurrStatus')[0].innerText;
			title = title.substr(0,title.indexOf($g("报告状态"))+5);
            top.$('#CurrStatus').text(title+$g("排除"));
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
			//必填项判断
			if((aType=="Submit")&&((ItemValue=="")||(ItemValue=="def"))&&(ItemBTIsNeeded=="是")&&(tmprow.EditPower=='1')){
				var Itemstr=Itemstr+"^"+ItemBTDesc
				num=num+1;
			}
			
			if (WarningInfo!=""){
				//错误信息提示
				ErrorInfo=ErrorInfo+ItemBTDesc+":"+WarningInfo+"<hr/>"
			}else if(ItemValue!=""){
				//没有直接错误提示的，再次执行校验（防止初始化值，逃过项目校验）
				var WarningInfo=obj.ValiItem(tmprow)
				if (WarningInfo!="") {
					rIndx=$('#gridQCFormShow').datagrid('getRowIndex',tmprow.BTCode);
					$("#gridQCFormShow").datagrid("updateRow",{  
		    	       index:rIndx, //行索引  
		        	   row:{  
		            		ExecWarning:WarningInfo
		            	  }  
			 		})	
			 		ErrorInfo=ErrorInfo+ItemBTDesc+":"+WarningInfo+"<hr/>"	
				}
			}
			
		}
		if (num>0) ErrorInfo=ErrorInfo+$g('必填项未填项目数')+'【'+num+'】<br/>';
		if(ErrorInfo!=""){
			$.messager.alert($g("错误提示"),ErrorInfo,'error')
			return false;
		}else {
			return true;
		}
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
					$('#btnCheckRep').linkbutton({text:'审核'});
					$('#btnCheckRep').show();
					$('#btnBackSD').show();
					$('#btnUpInfo').hide();
					$('#btnOutSD').show();
					$('#btnExport').show();
					break;
				case 'Save':
					$('#btnSaveTmpInfo').show();
					$('#btnSaveInfo').show();
					$('#btnCheckRep').hide();
					$('#btnBackSD').show();
					$('#btnUpInfo').hide();
					$('#btnOutSD').show();
					$('#btnExport').hide();
					break;
				case 'Back':
					$('#btnSaveTmpInfo').show();
					$('#btnSaveInfo').show();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnUpInfo').hide();
					$('#btnOutSD').show();
					$('#btnExport').hide();
					break;
				case 'I':
					$('#btnSaveTmpInfo').show();
					$('#btnSaveInfo').show();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnUpInfo').hide();
					$('#btnOutSD').show();
					$('#btnExport').hide();
					break;
				case 'O':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').hide();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnUpInfo').hide();
					$('#btnOutSD').hide();
					$('#btnExport').hide();
					break;
				case 'E':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').hide();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnUpInfo').hide();
					$('#btnOutSD').hide();
					$('#btnExport').hide();
					break;
				case 'Check':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').hide();
					$('#btnCheckRep').linkbutton({text:'取消审核'});
					$('#btnBackSD').hide();
					$('#btnOutSD').hide();
					$('#btnUpInfo').show();
					$('#btnExport').show();
					break;
				case 'Up':
					$('#btnSaveTmpInfo').hide();
					$('#btnSaveInfo').hide();
					$('#btnCheckRep').hide();
					$('#btnBackSD').hide();
					$('#btnOutSD').hide();
					$('#btnUpInfo').hide();
					$('#btnExport').show();
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
	$('#btnExport').on('click',function(){
		$('#gridQCFormShow').datagrid('toExcel','单病种表单.xls');	
		});
	obj.CalcValue=function(){
		ScoreArr[editIndex]=new Array();
		var checkList = document.getElementsByTagName("input"), chkCount = 0;
		for (var i=0; i<checkList.length; i++) {
			if (checkList[i].checked) {
				chkCount = chkCount + parseInt(checkList[i].value);
				var chkCodestr=checkList[i].id
				var ItemCode=chkCodestr.split('-')[0]
				var DicCode=chkCodestr.split('-')[1]
				if (!ScoreArr[editIndex][ItemCode]) {
					ScoreArr[editIndex][ItemCode]=new Array()
				}
				ScoreArr[editIndex][ItemCode].push(DicCode);
			}
	}
	var ed = $('#gridQCFormShow').datagrid('getEditor', {index:editIndex,field:'ExecResult'});
	$(ed.target).val(chkCount);
}
obj.ValiItem=function(rd){
		var WarningInfo=""
		/*去掉最初项目信息维护的校验规则，统一通过校验规则结构*/
		if (rd.ExecResult=="") return ""; //如果当前项目值为空，则放弃该条校验
		var RuleItemCodeStr=$m({
			ClassName:"DHCMA.CPW.SDS.QCItemValidRuleSrv",
			MethodName:"GetRuleItemCode",
			aItemCode:rd.BTCode,
			aQCID:obj.QCID,
			aVerID:obj.VerID
		},false)
		var RCodeArr=RuleItemCodeStr.split('^')
		RValueStr=""
		for (var i=0;i<RCodeArr.length;i++){
			var RCodei=RCodeArr[i]
			if (RCodei=="") continue;
			var rowIndex=$('#gridQCFormShow').datagrid('getRowIndex',RCodei);
			var row=$('#gridQCFormShow').datagrid('getRows')[rowIndex]
			if((typeof(row)=='undefined')||(row.EditPower=="0")) {
				var RValuei=""
			}else{
				var RValuei=row.ExecResult
			}
			if (RValuei=='undefined') RValuei="";
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
			aItemValStr:RValueStr,
			aQCID:obj.QCID,
			aVerID:obj.VerID,
			aLangID:session['LOGON.LANGID']
		},false)
		WarningArr=WarningInfo.split('&');
		for (var i=0;i<WarningArr.length;i++){
			var xvalue=WarningArr[i]
			var RuleType=xvalue.split('^')[1]
			var value=xvalue.split('^')[0]
			if (RuleType=='stop') {
				$.messager.confirm($g("提示"), value+","+$g("是否退出并排除这份病例")+"?", function (r) {	
					if (r) {
						//后台直接排除，不再走排除操作流程
						var RuleInputStr=MrListID+"^O^"+session['LOGON.USERID']+"^^"+value
						var flg = $m({
							ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
							MethodName:"ChangeMrlistSatus",
							aInput:RuleInputStr
						},false);
						websys_showModal('close');
					}else{
						var rowIndex=$('#gridQCFormShow').datagrid('getRowIndex',rd.BTCode);
						$("#gridQCFormShow").datagrid("updateRow",{  
		                   index:rowIndex, //行索引  
		                   row:{
			                   ExecResult:"",
			                   ExecWarning:""
		                   }  
		            	});	
		            	obj.ChangeRowEditor('',rd.BTCode)
					}	
				})			
			}
		}
		return WarningInfo
	}	
	obj.DisplayEPRView=function(EpisodeID,PatientID){
		
		if (!EpisodeID) return;
		if (cspUrl=="") cspUrl="./epr.newfw.episodelistbrowser.csp"
		/*
		var strUrl = cspUrl+"?EpisodeID=" + EpisodeID + "&PatientID=" + PatientID + "&2=2";
		var r_width = window.screen.availWidth-50;
		var r_height = window.screen.availHeight-100;
		var v_left = (window.screen.availWidth - 10 - r_width) / 2;		// 获得窗口的水平位置;
		var v_top = (window.screen.availHeight - 30 - r_height) / 2;	// 获得窗口的垂直位置;
		var r_params = "left=" + v_left +
						",top=" + v_top + 
						",width=" + r_width + 
						",height=" + r_height + 
						",status=yes,toolbar=no,menubar=no,location=no";
		window.open(strUrl, "_blank", r_params);
		*/
		var strUrl = cspUrl+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&2=2";
		 websys_showModal({
			url:strUrl,
			title:$g('浏览病历'),
			iconCls:'icon-w-edit',  
			//onBeforeClose:function(){alert('close')},
			//dataRow:{ParamRow:obj.ItemRowData},   //？
			originWindow:window,
			width:1300,
			height:600
		});
	}
}
function Unhtml(strDicList,o,n) {
	var reg=new RegExp(o,'g')
	return strDicList.replace(reg,n)
}
