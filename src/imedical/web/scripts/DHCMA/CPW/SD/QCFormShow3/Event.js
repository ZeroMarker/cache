//页面Event
function InitWinEvent(obj){
	$('#winConfirmInfo').dialog({
		title: '',
		iconCls:"icon-edit",
		closed: true,
		modal: true,
		isTopZindex:true	
	});
	obj.LoadEvent=function(){
		$('input').click(function(){
			itemcode=$(this)[0].id
			itemclass=$(this)[0].className
			if (itemclass.indexOf('combox')>-1) {
				var multi=false
				if (itemclass.indexOf('mul')>-1) multi=true
				obj.CreatCombo(itemcode,multi)
				$('#'+itemcode).combobox('showPanel');
			}else if(itemclass.indexOf('date')==0) {
				if (itemclass.indexOf('time')>-1){
					var ashowSeconds=false;
					if (itemclass.indexOf('timeS')>-1) ashowSeconds=true;
					$('#'+itemcode).datetimebox({
						width:tdWidth,
						showSeconds:ashowSeconds,
						onChange:function(v){
							obj.fireEvent($(this)[0].id,v)
						}
					});
					$('#'+itemcode).datetimebox('showPanel');
				}else{
					$('#'+itemcode).datebox({
						width:tdWidth,
						onSelect:function(date){
							var v=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
							obj.fireEvent($(this)[0].id,v)
						}
					});
					$('#'+itemcode).datebox('showPanel');
				}
			}else if(itemclass=='number') {	
				$('#'+itemcode).numberbox({
				    min:0,
				    precision:2,
				    width:tdWidth
				});
				$(this).focus();
			}else if(itemclass=='integer') {
				$('#'+itemcode).numberbox({
					width:tdWidth	
				})
				$(this).focus();
			}
		})
		$('.text,.integer,.number').on('keyup',function(){
			obj.fireEvent($(this)[0].id,$(this).val())
		})
		$('button').click(function(){
			btcode=$(this)[0].id	
			switch (btcode) {
		    	case "Save": case "Submit":
			        obj.saveReport(btcode);
			        break;
				case "export":
			        obj.ExportRep();
			        break;
			    default:
			        obj.UpdateStatus(btcode);
			        break;
			}
		})
		//保存排除原因
		$('#SaveRule').on('click',function () {
			var RuleStr=Common_CheckboxValue('RuleDic')
			var Resume=$('#RuleResume').val()
			var RuleInputStr=MrListID+"^O^"+session['LOGON.USERID']+"^"+RuleStr+"^"+Resume
			var flg = $m({
				ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
				MethodName:"ChangeMrlistSatus",
				aInput:RuleInputStr
			},false);
			if (parseInt(flg) < 0) {
				$.messager.alert("错误提示","排除失败!Error=" + flg, 'info');	
			} else {
				$.messager.alert('提示','排除成功！','success');
				obj.curStatus="O";
				obj.InitMrButtons();
				
			}
			$HUI.dialog('#winConfirmInfo').close();
		})
		$('#checkRep').on('click',function () {
			var ValiMsg=obj.valiForm('');
			if (ValiMsg) {
				$.messager.alert("错误提示",ValiMsg,'error');
			}else{
				$.messager.alert('提示','校验通过！','success');
			}
		})
		$('#expandRep').on('click',function () {
			for (var i = 0; i < ValiCat.length; i++){
				var xitemCat=ValiCat[i]
				$('div[title="'+xitemCat+'"]').css({'display':'block'});
				$('div[title="'+xitemCat+'"]').prev().removeClass('itemCat-fold');
			}
		})
		$('#collRep').on('click',function () {
			for (var i = 0; i < ValiCat.length; i++){
				var xitemCat=ValiCat[i]
				$('div[title="'+xitemCat+'"]').css({'display':'none'});
				$('div[title="'+xitemCat+'"]').prev().addClass('itemCat-fold');
			}
		})
		$('#toTopRep').on('click',function () {
			document.getElementById('SDNotice').scrollIntoView()
		})
		$('.score-table').on('click',function(){
			var scoreid=$(this).attr('id');
			var scoretitle=$(this).attr('title');
			var sheetCode=scoreid.replace('Score','');
			//获取评分工具对应的项目
			obj.EQCItemCode=$(this).parent().attr('id').replace("Row","");
			obj.showEvalSheet(sheetCode,scoretitle);
			obj.displaySheet(obj.EQCItemCode);
		})
		$('#ExitScore').on('click',function () {
			var tscore=$('#tScore').text();
			var tsval=$('#tScore').val();
			obj.setItemVal(obj.EQCItemCode,tscore,tsval);
			$HUI.dialog('#winVal').close();
		})
		$('#showEMR').on('click',function () {
			var AdmStr=$m({
				ClassName:'DHCMA.CPW.SDS.QCMrListSrv',
				MethodName:'GetAdmInfoByMrListID',
				aMrListID:MrListID	
			},false)
			var EpisodeID=AdmStr.split('^')[0];
			var PatientID=AdmStr.split('^')[1];
			Common_showEMR(EpisodeID,PatientID,"");
		})
		$('#SynFormData').on('click',function () {
			$.messager.progress({
					title: "提示",
					msg: '正在同步表单数据',
					text: '同步数据中....'
				}) 
			$m({
				ClassName:'DHCMA.CPW.SDS.QCItemExecSrv',
				MethodName:'refreshForm',
				MrListID:MrListID
			},function(ret){
				$.messager.popover({msg: "表单数据同步成功！",type:'success',timeout: 2000});
				location.reload();
				$.messager.progress("close");
			})
		})
		$('#showRule').on('click',function () {
			url="./dhcma.cpw.sd.qcruleshow.csp?QCID=" + obj.QCID + "&random="+Math.random();
			websys_showModal({
				url:url,
				title:"公告",
				width:'50%',
				iconCls:'icon-w-epr',
				originWindow:window,
				isTopZindex:true,
				onBeforeClose:function(){}
			});
		})
		
	}
	obj.InitMrButtons=function(){
		switch (obj.curStatus) {
	    	case "Save":  case "I":
	    		$('#Save').show();
	    		$('#Submit').show();
	    		$('#Back').show();
	    		$('#O').show();
	    		$('#Check').hide();
	    		$('#UnCheck').hide();
	    		$('#Up').hide();
	    		$('#export').hide();
		        break;
	    	case "Submit":
		        $('#Save').hide();
	    		$('#Submit').show();
	    		$('#Back').show();
	    		$('#O').show();
	    		$('#Check').show();
	    		$('#UnCheck').hide();
	    		$('#Up').hide();
	    		$('#export').hide();
		        break;
			case "Back":
		        $('#Save').show();
	    		$('#Submit').show();
	    		$('#Back').hide();
	    		$('#O').show();
	    		$('#Check').hide();
	    		$('#UnCheck').hide();
	    		$('#Up').hide();
	    		$('#export').hide();
		        break;
		    case "O":
		        $('#Save').hide();
	    		$('#Submit').hide();
	    		$('#Back').hide();
	    		$('#O').hide();
	    		$('#Check').hide();
	    		$('#UnCheck').hide();
	    		$('#Up').hide();
	    		$('#export').hide();
		        break;
		    case "Check":
		        $('#Save').hide();
	    		$('#Submit').hide();
	    		$('#Back').hide();
	    		$('#O').hide();
	    		$('#Check').hide();
	    		$('#UnCheck').show();
	    		$('#Up').show();
	    		$('#export').show();
		        break;
		    case "UnCheck":
		        $('#Save').hide();
	    		$('#Submit').show();
	    		$('#Back').show();
	    		$('#O').show();
	    		$('#Check').show();
	    		$('#UnCheck').hide();
	    		$('#Up').hide();
	    		$('#export').hide();
		        break;
		     case "tUp":
		        $('#Save').hide();
	    		$('#Submit').hide();
	    		$('#Back').hide();
	    		$('#O').hide();
	    		$('#Check').hide();
	    		$('#UnCheck').hide();
	    		$('#Up').show();
	    		$('#export').hide();
		        break;
		     case "Up":
		        $('#Save').hide();
	    		$('#Submit').hide();
	    		$('#Back').hide();
	    		$('#O').hide();
	    		$('#Check').hide();
	    		$('#UnCheck').hide();
	    		$('#Up').hide();
	    		$('#export').hide();
		        break;
		    default:
		        $('#Save').hide();
	    		$('#Submit').hide();
	    		$('#Back').hide();
	    		$('#O').hide();
	    		$('#Check').hide();
	    		$('#UnCheck').hide();
	    		$('#Up').hide();
	    		$('#export').hide();
		        break;
		}
		if ((tDHCMedMenuOper['LocAdmin']!=1)&&(tDHCMedMenuOper['HosAdmin']!=1)&&(tDHCMedMenuOper['admin']!=1))
		{
			//如果非管理员，用户无审核、取消审核、退回、上传权限
			$('#Check').hide();
			$('#UnCheck').hide();
			$('#Back').hide();
			$('#Up').hide();
		}
		if (ViewFlg) { //如果只是浏览 不展现操作按钮
			$('#Save').hide();
    		$('#Submit').hide();
    		$('#Back').hide();
    		$('#O').hide();
    		$('#Check').hide();
    		$('#UnCheck').hide();
    		$('#Up').hide();
    		$('#export').hide();
		}
		var StatusDesc=(obj.curStatus=="I"?"已确认":obj.curStatus=="Check"?"审核":obj.curStatus=="UnCheck"?"取消审核":obj.curStatus=="Up"?"上报":obj.curStatus=="tUp"?"测试上报":obj.curStatus=="O"?"排除":obj.curStatus=="Back"?"退回":obj.curStatus=="Save"?"保存":obj.curStatus=="Submit"?"提交":"")
		$('#FormStatus').text(StatusDesc);
	}
	obj.InitMrButtons();
	obj.saveReport=function(aCode) {
		var Err=""	
		//保存操作检查是否有编辑过的项目
		if ((EditItem.length==0)&&(aCode=='Save')) {
			$.messager.alert("错误提示", "没有编辑过的项目需要保存", 'info');
			return
		}
		//填报值校验
		var valiMsg=""
		if (aCode=="Save") {
			//检查所编辑的项目有无错误信息，有错则不进行保存
			for (var xind=0;xind<EditItem.length;xind++) {
				var xcode=EditItem[xind]
				var xNote=$('#'+xcode+'Note').html()
				xNoteArr=xNote.split('<br>')
				for (var yind=0;yind<xNoteArr.length;yind++) {
					var yNote=xNoteArr[yind]
					if (yNote.indexOf(':red')>-1) {
						var einfo=$('#'+xcode+'Row').children().first()[0].innerHTML+"-"+yNote
						valiMsg=valiMsg+einfo+"<br>"
					}
				}
			}
			if (valiMsg) {
				$.messager.alert("错误提示",valiMsg, 'error');
				return
			}
		}else if(aCode=="Submit"){
			var valiMsg=obj.valiForm('');	
			if (valiMsg) {
				$.messager.alert("错误提示",valiMsg, 'error');
				return
			}
		}
		var EditItemStr=EditItem.join(String.fromCharCode(1))
		var EditValStr=EditVal.join(String.fromCharCode(1))
		var InputStr=MrListID+"^"+EditItemStr+"^"+EditValStr+"^"+session['LOGON.USERID']
		var flg=$m({
				ClassName:"DHCMA.CPW.SDS.QCItemExecSrv",
				MethodName:"InsertItemValue",
				aInputStr:InputStr
			},false)
		if (parseInt(flg)<1) {
			Err=flg.split('^')[1]
		}
		if (Err!="") {
			$.messager.alert("错误提示", "数据保存错误!键值明细:" + Err, 'info');
		}else{
			$.messager.alert("提示", aCode+"操作成功", 'success');
			//增加状态操作记录
			if (EditItem.length==0) { //如果当次操作没有变更表单，则不记录开始编辑日期
	       		obj.OperStartTime="";
			}
			var StateStr=MrListID+"^"+aCode+"^"+session['LOGON.USERID']+"^^^"+obj.OperStartTime
			var ErrInfo=$m({
					ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
					MethodName:"ChangeMrlistSatus",
					aInput:StateStr
				},false)
			if (ErrInfo){
				$.messager.alert("错误提示", "状态更新错误!Error=" + ErrInfo, 'info');
			}
			//提交成功 且 配置临床提交表单后直接上报，直接调用上报接口
			var DirectReport=$m({
				ClassName:'DHCMA.Util.BT.Config',
				MethodName:'GetValueByCode',
				aCode:'SDDirectReport'
			})
			if ((aCode=="Submit")&&(DirectReport=="1")) {
				//提交成功且允许临床直报，直接调用上报函数
				obj.UpdateStatus("Up");	 
			}
			//操作成功后  清除编辑值记录
			obj.curStatus=aCode;
			obj.InitMrButtons();
			EditItem=[]
			EditVal=[]
			
			//操作完成后，重置下个操作的开始日期时间
			var date=new Date();
		}
	}
	//校验整个表单项目的合法性
	obj.valiForm=function(aitemcat){
		data=obj.formdata
		var ValiMsg="",count=0,ecount=0
		var ErrCat=new Array();
		var length=data.rows.length
		for (var i=0;i<length;i++) {
			var Code	= data.rows[i].BTCode
			var Value	= data.rows[i].ExecResult
			var Desc	= data.rows[i].BTDesc
			var ItemCat	= data.rows[i].BTItemCat
			//校验指定项目大类
			if ((aitemcat!=="")&&(aitemcat!=ItemCat)) continue;
			var RowCls=$('#'+Code+'Row').css('display')
			if (RowCls=='none') continue;			//如果项目没展现，则不再校验
			var newValue=Common_GetSDValue(Code)
			if (newValue=='def') newValue="";
			var html=$('#'+Code+'Note').html();
			if (html.indexOf('必填项')>-1) {		//如果有校验信息，则不再校验
				var count=count+1
				if (ErrCat.indexOf(ItemCat)<0) ErrCat.push(ItemCat);
				continue;
			}else if(html!=""){
				var einfo=Desc+"-"+html
				var ValiMsg=ValiMsg+einfo
				ecount=ecount+1
				if (ErrCat.indexOf(ItemCat)<0) ErrCat.push(ItemCat);
				continue;
			}
			
			if ((obj.initFlg==1)&&(newValue!="")) {continue;} 		//如果已经全局校验过，有值的项目则不需要校验
			if ((newValue=="")&&($('#'+Code+'Row')[0].innerText.indexOf('*')>-1)) {
				WarningInfo="必填项不能为空"	
				$('#'+Code+'Note').html('<span style="color:red">'+WarningInfo+'</span>');
			}else if((Value!="")&&(Value==newValue)) {
				//对没有进行过编辑，且有初始值的项目进行校验
				//对已经编辑过的项目，已经做了实时校验，这里不再统一校验
				obj.ValiItem(Code,Value);			
			}
			var html=$('#'+Code+'Note').html();	
			if (html.indexOf('必填项')>-1) {
				var count=count+1
				if (ErrCat.indexOf(ItemCat)<0) ErrCat.push(ItemCat);
			}else if(html!="") {
				var einfo=Desc+"-"+html
				var ValiMsg=ValiMsg+einfo
				ecount=ecount+1
				if (ErrCat.indexOf(ItemCat)<0) ErrCat.push(ItemCat);
			}
		}
		var needVali=""
		if (count>0) {
			var needVali='共 '+count+' 项必填项未填'
		}
		if (aitemcat=="") {
			obj.initFlg=1; //全局校验标记，防止多次校验影响网页速度
		}else {
			//对单个大类校验时，进行错误信息提示。
			var errorinfo=needVali
			if (ecount>0) errorinfo=errorinfo+" 错误项 "+ecount+" 项";
			if(errorinfo!="") $('div[title="'+aitemcat+'"]').prev().attr({'errorInfo':" ("+errorinfo+")"});	
			else $('div[title="'+aitemcat+'"]').prev().attr({'errorInfo':""});	
		}
		//标记已经完成和有填报错误的大类
		if (aitemcat!="") {
			if (ErrCat.indexOf(aitemcat)>-1) {
				$('div[title="'+aitemcat+'"]').prev().css({'color':'red'});
			}else{
				$('div[title="'+aitemcat+'"]').prev().css({'color':'green'});
			}
		}else {
			for (var i = 0; i < ValiCat.length; i++){
				var xitemCat=ValiCat[i]
				$('div[title="'+xitemCat+'"]').prev().attr({'errorInfo':''});
				if (ErrCat.indexOf(xitemCat)>-1) {
					$('div[title="'+xitemCat+'"]').prev().css({'color':'red'});
				}else{
					$('div[title="'+xitemCat+'"]').prev().css({'color':'green'});
					$('div[title="'+xitemCat+'"]').css({'display':'none'});
					$('div[title="'+xitemCat+'"]').prev().addClass('itemCat-fold');
				}
			}
		}
		if (needVali!="") ValiMsg='<span style="color:red">'+needVali+'</span><br>'+ValiMsg
		return ValiMsg;
	}
	obj.UpdateStatus=function(aCode) {
		if (aCode=="") return;
		var ErrInfo="";
		var SDesc=(aCode=="Check"?"审核":aCode=="UnCheck"?"取消审核":aCode=="Up"?"上报":aCode=="O"?"排除":aCode=="Back"?"退回":"")
		$.messager.confirm("提示", "是否"+SDesc+"这份病例?", function (r) {				
			if (r) {
				if (aCode=="Up") {
					$.messager.progress({
							title: "提示",
							msg: '正在上传数据',
							text: '上传中....'
					});
					$m({
						ClassName:'DHCMA.CPW.SDS.QCInterface',
						MethodName:'Upload',
						aMRListID:MrListID	
					},function(UpRet){
						$.messager.progress("close")
						var UpRetArr=UpRet.split('^')
						var msginfo="已正式上传至国家平台！",statusDesc="正式上传",aCode="Up"
						if (UpRetArr[0]==1) {
								if (UpRetArr[1]=="") {
									var msginfo="测试上传成功，请联系信息中心正式对接平台！";
									var aCode="tUp";
									var statusDesc="测试上传";
								}
								$.messager.popover({msg: msginfo,type:'success',timeout: 1000})
								//改变表单状态
								var StateStr=MrListID+"^"+aCode+"^"+session['LOGON.USERID']
								ErrInfo=$m({
											ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
											MethodName:"ChangeMrlistSatus",
											aInput:StateStr
									},false)
								obj.curStatus=aCode;
								obj.InitMrButtons();
							}else if(UpRet.indexOf('病案号重复')>0){	
								//改变表单状态
								var StateStr=MrListID+"^"+aCode+"^"+session['LOGON.USERID']
								ErrInfo=$m({
											ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
											MethodName:"ChangeMrlistSatus",
											aInput:StateStr
									},false)
								if (ErrInfo){
										$.messager.popover({msg: '已存在上传记录，更新上传状态错误'+ErrInfo+'！',type:'success',timeout: 3000})
									}else{
										$.messager.popover({msg: '已存在上传记录，更新上传状态成功！',type:'success',timeout: 3000})
										obj.curStatus=aCode;
										obj.InitMrButtons();
								}
								
							}else{
								$.messager.alert("错误提示", "表单上传失败:" + UpRet, 'info');
							}		
					});	
				}else if (aCode=="O") {
					//弹窗选择取消确认理由，或填写备注	
					Common_CheckboxToSDRule("RuleDic",obj.QCID,2,1);	
					$('#winConfirmInfo').dialog({
						title: '排除单病种【信息录入】',
						height: 450 
					})
					$HUI.dialog('#winConfirmInfo').open();
				}else if(aCode=="Back"){
					//退回报告需要填写退回原因
					$.messager.prompt("提示", "请输入退回原因：", function (r) {
						if (r) {
							var StateStr=MrListID+"^"+aCode+"^"+session['LOGON.USERID']+"^^"+r;
							ErrInfo=$m({
								ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
								MethodName:"ChangeMrlistSatus",
								aInput:StateStr
							},false)
							$.messager.popover({msg: SDesc+'操作成功！',type:'success',timeout: 1000});
							obj.curStatus=aCode;
							obj.InitMrButtons();
						} else {
							$.messager.popover({msg:"您撤销了退回操作！",type:'info'});
						}
					});
				}else{	
					if (aCode=="Check") {
						obj.saveReport('Check');
					}	
					var StateStr=MrListID+"^"+aCode+"^"+session['LOGON.USERID']
					ErrInfo=$m({
						ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
						MethodName:"ChangeMrlistSatus",
						aInput:StateStr
					},false)
					if (ErrInfo){
						$.messager.alert("错误提示", "状态更新错误!Error=" + ErrInfo, 'info');
					}else{
						$.messager.popover({msg: SDesc+'操作成功！',type:'success',timeout: 1000})
						obj.curStatus=aCode;
						obj.InitMrButtons();
					}
				}			
			}
		})	
	}
	obj.fireEvent=function(ItemCode,Value){
		//触发项目变更时，自动展现各级关联项目去重处理，防止项目嵌套导致无限循环展现
		autoShowedCodeArr=new Array()
		
		if (obj.addListener==0) {
			return false;
		}else {
			if ((Value=="")||(Value==undefined)) {
				//列表值变化没有传入值，取列表值
				Value=Common_GetSDValue(ItemCode);
			}
			//将编辑过的值存储起来，方便后面保存
			var icodeIndx=EditItem.indexOf(ItemCode)
			if (icodeIndx>-1){
				EditVal.splice(icodeIndx,1,Value)	
			}else {
				EditItem.push(ItemCode);
				EditVal.push(Value);
			}
			//根据该项目值判断相关联项目的展现/隐藏属性
			obj.autoShowItem(ItemCode,Value);
			//对该项目合法性进行校验
			obj.ValiItem(ItemCode,Value);
			
			//加载相关项目值（值域范围或者默认值）
			obj.LoadSubItemDic(ItemCode);
			
		}
	}
	//展现/隐藏项目
	obj.autoShowItem=function(ItemCode,Value){
		autoShowedCodeArr[ItemCode]=true
		var relativeCode=$m({
				ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
				MethodName:"GetRelativeItemCode",
				aCode:ItemCode,
				aQCID:obj.QCID,
				aVerID:obj.VerID
		},false)
		var RCodeArr=relativeCode.split('^')
		RCodeStr="",RValueStr=""
		for (var i=0;i<RCodeArr.length;i++){
			var RCodei=RCodeArr[i]
			if (RCodei=="") continue;
			var RValuei=Common_GetSDValue(RCodei)
			if (RValuei==undefined) RValuei="";
			if (("^"+RCodeStr+"^").indexOf("^"+RCodei+"^")>0) continue;
			RCodeStr=RCodeStr+"^"+RCodei
			if (ItemCode==RCodei) {
				RValueStr=RValueStr+"^"+Value;
			}else{
				RValueStr=RValueStr+"^"+RValuei;
			}
		}
		$m({
			ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
			MethodName:"GetLinkItemSH",
			aValueStr:RValueStr,
			aCodeStr:RCodeStr,
			aQCID:obj.QCID,
			aVerID:obj.VerID
			},function(data){
				var LinkSubItemCodeArr=data.split('`')
				for (var CodeIndex=0;CodeIndex<LinkSubItemCodeArr.length;CodeIndex++) {
					var EditPower=LinkSubItemCodeArr[CodeIndex].split('^')[0]
					var tCode=LinkSubItemCodeArr[CodeIndex].split('^')[1]
					if ((tCode=="")||(tCode==undefined)) continue;
					if (EditPower==1) {
						$('#'+tCode+"Row").show()
						//判断子标题是否需要显示
						if ($('#'+tCode+"Row").prev()[0].className=='itemsubCat')
						{
							$('#'+tCode+"Row").prev().show()
						}
						//如果子项的值不为空，则继续判断其子项是否展现
						var tValue=Common_GetSDValue(tCode)
						if ((tValue!="")&&(!autoShowedCodeArr[tCode])){
							obj.autoShowItem(tCode,tValue)	
						}
					}else{
						$('#'+tCode+"Row").hide()
						//判断子标题是否需要隐藏
						if ($('#'+tCode+"Row").prev()[0].className=='itemsubCat')
						{
							$('#'+tCode+"Row").prev().hide()
						}
					}
				}
		})
	}
	//对该项目进行校验
	obj.ValiItem=function(ItemCode,Value){
		//清空历史信息，准备显示最新的校验信息
		$('#'+ItemCode+'Note').html('');
		if ((Value=="")&&($('#'+ItemCode+'Row')[0].innerText.indexOf('*')>-1)) {
			WarningInfo="必填项不能为空"	
			$('#'+ItemCode+'Note').html('<span style="color:red">'+WarningInfo+'</span>');
			return
		}
		var RuleItemCodeStr=$m({
			ClassName:"DHCMA.CPW.SDS.QCItemValidRuleSrv",
			MethodName:"GetRuleItemCode",
			aItemCode:ItemCode,
			aQCID:obj.QCID,
			aVerID:obj.VerID
		},false)
		var RCodeArr=RuleItemCodeStr.split('^')
		var RValueStr=""
		for (var i=0;i<RCodeArr.length;i++){
			var RCodei=RCodeArr[i]
			if (RCodei=="") continue;
			var RValuei=Common_GetSDValue(RCodei)
			if (RValuei==undefined) RValuei="";
			if (i==0) {
				RValueStr=RValuei
			}else {
				RValueStr=RValueStr+"^"+RValuei;
			}
		}
		
		var WarningInfo=$m({
			ClassName:"DHCMA.CPW.SDS.QCItemValidRuleSrv",
			MethodName:"GetValiMsg",
			aItemCode:ItemCode,
			aItemValue:Value,
			aItemCodeStr:RuleItemCodeStr,
			aItemValStr:RValueStr,
			aQCID:obj.QCID,
			aVerID:obj.VerID	
		},false)
		if (WarningInfo=="") {
			$('#'+ItemCode+'Note').html('');
			return;
		}
		WarningArr=WarningInfo.split('&');
		for (var i=0;i<WarningArr.length;i++){
			var xvalue=WarningArr[i]
			var RuleType=xvalue.split('^')[1]
			var value=xvalue.split('^')[0]
			if (RuleType=='stop') {
				$.messager.confirm("提示", value+",是否退出并排除这份病例?", function (r) {	
					if (r) {
						obj.UpdateStatus('O');
					}else{
						//清空选项值
						$('[name="'+ItemCode+'"][value="'+Value+'"]').radio('setValue', false);
						obj.fireEvent(ItemCode,'');
					}
				})			
			}else if (RuleType=='error') {
				$('#'+ItemCode+'Note').append('<span style="color:red">'+value+'</span><br/>')		
			}else{
				$('#'+ItemCode+'Note').append('<span style="color:#40A2DE;">'+value+'</span><br/>')	
			}
		}
	}
	obj.LoadSubItemDic=function(itemcode){
		var multi=false
		switch (itemcode) 
		{
			case 'CM-0-1-3-1':           //主要诊断ICD-10四位亚目编码与名称
				var alias=obj.GetItemKeys(itemcode)
				if ($('#CM-0-1-3-2')[0]) { //判断子项目是否存在
					itemclass=$('#CM-0-1-3-2')[0].className
					if (itemclass.indexOf('mul')>-1) multi=true;
					obj.CreatCombo('CM-0-1-3-2',multi,alias)
				}
				break;
			case 'CM-0-1-4-1':			//主要手术操作栏中提取ICD-9-CM-3四位亚目编码与名称
				var alias=obj.GetItemKeys(itemcode)
				if ($('#CM-0-1-4-2')[0]) { //判断子项目是否存在
					itemclass=$('#CM-0-1-4-2')[0].className
					if (itemclass.indexOf('mul')>-1) multi=true;
					obj.CreatCombo('CM-0-1-4-2',multi,alias)
				}
				break;
			default:
				break
		}
	}
	obj.GetItemKeys=function(itemcode) {
		var keys=""
		var preDesc=$('#'+itemcode).combobox('getText');
		var preDescArr=preDesc.split(',')
		for (var i=0;i<preDescArr.length;i++) {
			var subDesc=preDescArr[i]
			if (subDesc.indexOf(' ')<0) continue;  //非标准格式诊断编码，不进行过滤
			var subKey=subDesc.split(' ')[0]
			//正则表达式校验是否关键字只包含编码
			if (/^[A-Z0-9\.]+$/.test(subKey)) {
				keys+=subKey+","
			}
		}
		if (keys!='') keys=keys.substr(0,keys.length-1)	
		return keys
	}
	obj.CreatCombo=function(){
		var itemcode =arguments[0] ? arguments[0] : '';
  		var multi = arguments[1]!=='' ? arguments[1] : '';
  		var ifCheckBox = multi?'checkbox':'';
  		var alias = arguments[2]? arguments[2] : '';
		$HUI.combobox("#"+itemcode, {
			editable: false,       
			defaultFilter:4,     
			allowNull: true,
			width:tdWidth,
			multiple:multi,	
			rowStyle:ifCheckBox,
			valueField: 'BTCode',
			textField: 'BTDesc',
			url:$URL,
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCMA.CPW.SDS.DictionarySrv';
				param.QueryName = 'QryDictByType';
				param.aTypeCode = itemcode;
				param.aQCID 	= obj.QCID;
				param.aVersion 	= obj.VerID;
				param.aIsActive = 1;
				param.aKey		= alias;
				param.ResultSetType = 'array';
			}
			,onShowPanel: function () {
			}
			,onSelect:function(rec){
				if (multi) { ///父页面中直接打开dialog Combobox多选会有问题
					var combodata=$(this).combobox('getValues')
					$(this).combobox('getValues').forEach(function(element,index) {
					    if (!element) combodata.splice(index,1)
					});
					$(this).combobox('setValues',combodata);
					obj.fireEvent(itemcode,'');
				}else {
					obj.fireEvent(itemcode,rec.BTCode);
				}
			}
			,onLoadSuccess:function(data){
			}
		});
	}
	
	obj.toggle=function(aItemCat) {
		if ($('div[title="'+aItemCat+'"]').css('display')=='block') {
			//收起来的时候，校验必填项目
			$('div[title="'+aItemCat+'"]').css({'display':'none'});
			$('div[title="'+aItemCat+'"]').prev().addClass('itemCat-fold');
			obj.valiForm(aItemCat);
			
		}else{
			$('div[title="'+aItemCat+'"]').css({'display':'block'});
			$('div[title="'+aItemCat+'"]').prev().removeClass('itemCat-fold');
		}
	}
	///展现评分表内容
	obj.showEvalSheet=function(aSheetCode,aSheetTitle){
		var listHtml=""
		//初始化分值
		$('#tScore').text('');
		//计算滑动条位置，居中显示弹窗
		$('#winVal').dialog({top:$(window).scrollTop()-5});
		//动态生成评分表html
		var listHtml=listHtml+'<div>'
		var itemdata=$cm({
			ClassName:'DHCMA.CPW.SDS.EvalSrv',
			QueryName:'QryEItemByCode',
			aSheetCode:aSheetCode,
			rows:1000
		},false)
		var itemlen=itemdata.rows.length
		var itemPWidth='200px';
		if (itemlen==1) itemPWidth='98%';  //唯一评分项  展开全部 
		var listHtml=listHtml+'<div>'
		var itemhtml=""
		var HCount=0 //加载行div
		var itemCount=0 //默认列数
		for (var xind=0;xind<itemlen;xind++) {
			var xitem=itemdata.rows[xind]
			var itemid=xitem.RowID
			var itemcode=xitem.ICode
			var itemdesc=xitem.IDesc
			var multiple=xitem.IMul?true:false;
			//从代码处理当前项目位置信息
			var xitemcode=itemcode.replace(aSheetCode,"")
			var xitemcodeArr	= xitemcode.split('-')
			var xhcount			= xitemcodeArr[1]   //行位置
			var xvcount			= xitemcodeArr[2]	//列位置
			var xstyle			= xitemcodeArr[3]	//合并样式
			var IComb=xitem.IComb
			if (xhcount!=HCount) {
				itemCount=1 //默认一行一列
				if (HCount>0) {
					//给上一个div加上结束标签
					var itemhtml=itemhtml+'</div>'
				}
				if (IComb==3){
					var itemhtml=itemhtml+'<div class="item-h3" id="hdiv'+xhcount+'">'
				}else{
					var itemhtml=itemhtml+'<div class="item-h" id="hdiv'+xhcount+'">'
				}
				HCount=xhcount
				//新写入一行前，计算总列数
				for (var yind=xind+1;yind<itemlen;yind++) {
					var yitem=itemdata.rows[yind]
					var yitemcode=yitem.ICode
					var yitemcode=yitemcode.replace(aSheetCode,"")
					var yitemcodeArr	= yitemcode.split('-')
					var yhcount			= yitemcodeArr[1]   //行位置
					if (yhcount!=xhcount) break;
					var yvcount			= yitemcodeArr[2]	//列位置
					if (yvcount>0) itemCount=yvcount
				}
				
			}
			if (itemCount==0) continue;
			var itemdicdata=$cm({
				ClassName:'DHCMA.CPW.SDS.EvalSrv',
				QueryName:'QryEDicByItemID',
				aitemid:itemid,
				rows:1000
			},false)
			var itemdicLen=itemdicdata.rows.length
			if (IComb==3) {
				//横分表构建
				//第一个评分项构建评分表头
				var titlehtml="",dichtml=""
				if (xind==0) {
					//计算列宽
					var colWidth=99/(itemdicLen+1)+"%"
					//补项目分类头
					var titlehtml=titlehtml+'<div class="dic-title" style="width:'+colWidth+'">'+"项目"+'</div>'
					var dichtml='<div data-multiple='+multiple+'><div class="dic-title3" style="width:'+colWidth+'">'+itemdesc+'</div>'
					for (var dind=0;dind<itemdicLen;dind++) {
						var xitemdic=itemdicdata.rows[dind]
						var EDRowID	= xitemdic.RowID
						var EDCode	= xitemdic.EDCode
						var EDDesc	= xitemdic.EDDesc
						var EDScore	= xitemdic.EDScore	
						var EDType	= xitemdic.EDType
						var EDExp	= xitemdic.EDExp
						var EDGroup	= xitemdic.EDGroup
						var EDLink	= xitemdic.EDLink
						var titlehtml=titlehtml+'<div class="dic-title" style="width:'+colWidth+'">'+EDScore+'</div>'
						var dichtml=dichtml+'<div id='+EDRowID+' class="dic-desc" data-calc="'+EDExp+'"  data-score="'+EDScore+'" data-link="'+EDLink+'" data-group="'+EDGroup+'" style="width:'+colWidth+';">'+EDDesc+'</div>'
					}
					var dichtml=dichtml+'</div>'
					titlehtml='<div style="margin-top:10px;" class="item-h3" id="hdiv'+0+'">'+titlehtml+'</div>'
					dichtml='<div class="item-h3" id="hdiv'+1+'">'+dichtml+'</div>'
					itemhtml=titlehtml+dichtml
				}else {
					var dichtml='<div data-multiple='+multiple+'><div class="dic-title3" style="width:'+colWidth+'">'+itemdesc+'</div>'
					for (var dind=0;dind<itemdicLen;dind++) {
						var xitemdic=itemdicdata.rows[dind]
						var EDRowID	= xitemdic.RowID
						var EDCode	= xitemdic.EDCode
						var EDDesc	= xitemdic.EDDesc
						var EDScore	= xitemdic.EDScore	
						var EDType	= xitemdic.EDType
						var EDExp	= xitemdic.EDExp
						var EDGroup	= xitemdic.EDGroup
						var EDLink	= xitemdic.EDLink
						var dichtml=dichtml+'<div id='+EDRowID+' class="dic-desc" data-calc="'+EDExp+'"  data-score="'+EDScore+'" data-link="'+EDLink+'" data-group="'+EDGroup+'" style="width:'+colWidth+';">'+EDDesc+'</div>'
					}
					var dichtml=dichtml+'</div>'
					itemhtml=itemhtml+dichtml
				}
			}else if(IComb==2){
				var itemWidth=99/itemCount+"%"
				var itemhtml=itemhtml+'<div class="item-panel" data-multiple='+multiple+' style="width:'+itemWidth+';">'
				var itemhtml=itemhtml+'<div class="dic-title">'+itemdesc+'</div>'
				var itemdicLen=itemdicdata.rows.length
				for (var dind=0;dind<itemdicLen;dind++) {
					var xitemdic=itemdicdata.rows[dind]
					var EDRowID	= xitemdic.RowID
					var EDCode	= xitemdic.EDCode
					var EDDesc	= xitemdic.EDDesc
					var EDScore	= xitemdic.EDScore	
					var EDType	= xitemdic.EDType
					var EDExp	= xitemdic.EDExp
					var EDGroup	= xitemdic.EDGroup
					var EDLink	= xitemdic.EDLink
					var EDDesc=EDDesc.replace(/\r\n/g,"<br>")
					var itemhtml=itemhtml+'<div id='+EDRowID+' class="dic-desc" data-calc=\"'+EDExp+'\"  data-score=\"'+EDScore+'\" data-link=\"'+EDLink+'\" data-group=\"'+EDGroup+'\" style="float:left;width:98%;height:100%;">'+EDDesc+'</div>'
					var itemhtml=itemhtml+'<div style="clear:both"></div>'
				}
				var itemhtml=itemhtml+'</div>'
			}else{
				var itemWidth=99/itemCount+"%"
				var itemhtml=itemhtml+'<div class="item-panel" data-multiple='+multiple+' style="width:'+itemWidth+';">'
				var itemhtml=itemhtml+'<div class="dic-title">'+itemdesc+'</div>'
				var itemdicLen=itemdicdata.rows.length
				for (var dind=0;dind<itemdicLen;dind++) {
					var xitemdic=itemdicdata.rows[dind]
					var EDRowID	= xitemdic.RowID
					var EDCode	= xitemdic.EDCode
					var EDDesc	= xitemdic.EDDesc
					var EDScore	= xitemdic.EDScore	
					var EDType	= xitemdic.EDType
					var EDExp	= xitemdic.EDExp
					var EDGroup	= xitemdic.EDGroup
					var EDLink	= xitemdic.EDLink
					var EDDesc=EDDesc.replace(/\r\n/g,"<br>")
					var EDDesc=EDDesc.replace(/\s/g,"<br>")
					/*
					<input id="huodongdu" placeholder="8度=1分，最高18分">
					<div>每5度外翻<input id="waifandu">度</div>
					*/
					var itemhtml=itemhtml+'<div class="dic-score">'+EDScore+'</div>'
					if (EDType=="input") {
						if (EDExp=="") {
							var itemhtml=itemhtml+'<div style="float:left;"><input id='+EDRowID+' class="dic-input" placeholder='+EDDesc+'></div>'
						}else{
							var itemhtml=itemhtml+'<div style="float:left;">'+EDDesc+'<input id='+EDRowID+' data-calc=\"'+EDExp+'\" class="dic-input"></div>'
						}
					}else{
						var itemhtml=itemhtml+'<div id='+EDRowID+' class="dic-desc" data-calc=\"'+EDExp+'\"  data-score=\"'+EDScore+'\" data-link=\"'+EDLink+'\" data-group=\"'+EDGroup+'\" >'+EDDesc+'</div>'
					}
					var itemhtml=itemhtml+'<div style="clear:both"></div>'
				}
				var itemhtml=itemhtml+'</div>'
			}
			
		}	
		var listHtml=listHtml+itemhtml
		var listHtml=listHtml+'</div>'  //最后一个行div结束
		var listHtml=listHtml+'</div></div>'
		$('#ValDic').html(listHtml)
		$('#winVal').dialog({title:aSheetTitle})
		$HUI.dialog('#winVal').open();
		$.parser.parse('#ValDic');
		//选中div时 计算分值
		$('.dic-desc').on('click',function(){
			
			//如果容器标记为单选，则先移除所有选中，再选中当前
			if ($(this).parent().attr('data-multiple')=='false') {	
				if ($(this).hasClass('dic-desc-selected')) {
					$(this).parent().find('.dic-desc-selected').removeClass('dic-desc-selected');
				}else {
					$(this).parent().find('.dic-desc-selected').removeClass('dic-desc-selected');
					$(this).addClass('dic-desc-selected');	
				}
			}else{
				//如果容器标记为多选，则当前切换选中状态
				$(this).toggleClass('dic-desc-selected');
			}
			//搜索父容器下所有互斥项，取消所有互斥项的选中状态
			if ($(this).hasClass('dic-desc-selected')) {
				var selectedText=$(this).text();
				var selectedid=$(this)[0].id;
				var groupinfo=$(this).attr('data-group');
				var linkinfo=$(this).attr('data-link');
				if (groupinfo) {
					//清除同分组信息下的其他选项
					$('div[data-group='+groupinfo+']').each(function(i, v){
						if (selectedid!=$(this)[0].id) {
							$(this).removeClass('dic-desc-selected');
						}
					})
				}
				if (linkinfo) {
					//选中相关联的其他选项
					$('div').find('.dic-desc-selected').removeClass('dic-desc-selected');
					$('div[data-link='+linkinfo+']').each(function(i, v){
							$(this).addClass('dic-desc-selected');
					})	
				}
			}
			obj.CalVal(aSheetCode);
		})
		//输入框计算到总分值
		$('.dic-input').on('input',function(){
			obj.CalVal(aSheetCode);
		})
	}
	//每次选中/填写评估表，计算当前所得分值
	obj.CalVal=function(aSheetCode){
		//初始化评估得分、值、评分字典
		var tscore=0,tval="",selectdicstr=""
		obj.ScoreArr[obj.EQCItemCode]=""
		$('div').find('.dic-desc-selected').each(function(i, v){
			var xscore=$(this).attr('data-score')
			selectdicstr=selectdicstr+"^"+$(this).attr('id')
			if (!isNaN(parseInt(xscore))) {
				//分值评定，分值相加
				tscore=tscore+parseInt(xscore)
			}else {
				//等级评估，直接显示等级描述
				tscore=xscore
				//如果有计算表达式，按照计算公式进行转换
				texp=$(this).attr('data-calc')
				if (texp) {
					texp.replace('this',xscore)
					tval=eval('texp')	
				}
			}
		})
		
		$('.dic-input').each(function(i, v){
			texp=$(this).attr('data-calc')
			xscore=$(this).val()
			if (xscore!="") {
				if (texp) {
					texp=texp.replace(/this/g,xscore)
					//计算表达式结果值 保留2位小数
					xscore=eval(texp).toFixed(2)	
				}
				tscore=tscore+Number(xscore)
				selectdicstr=selectdicstr+"^"+$(this).attr('id')+"`"+$(this).val()
			}
		})
		if(!isNaN(tscore)) $('#tScore').text(Number(tscore.toFixed(2)));
		else $('#tScore').text(tscore);
		if (tval) {
			$('#tScore').val(tval)
		}
		obj.ScoreArr[obj.EQCItemCode]=tscore+"#"+selectdicstr
	}
	obj.setItemVal=function(aItemCode,atext,tsval) {
		EditItem.push(aItemCode);
		var itemClass=$('#'+aItemCode).attr('class');
		if (itemClass.indexOf('combox')>-1) {
			obj.CreatCombo(aItemCode,false);
			$('#'+aItemCode).combobox('setValue',tsval,atext);
			EditVal.push(tsval);
		}else{
			$('#'+aItemCode).val(atext)
			EditVal.push(atext);
		}
	}
	//初始化评估表内容
	obj.displaySheet=function(aCode) {	
		if (obj.ScoreArr[aCode]){
			var scoredicstr=obj.ScoreArr[aCode].split('#')[1]
			var scoredicArr=scoredicstr.split('^')
			for (var sind=1;sind<scoredicArr.length;sind++) {
				var dicid=scoredicArr[sind]
				if (dicid.indexOf('`')>-1) {
					$('[id="'+dicid.split('`')[0]+'"]').val(dicid.split('`')[1])
				}else{
					$('[id="'+dicid+'"]').addClass('dic-desc-selected')	
				}
			}	
			obj.CalVal()
		}	
	}
}
//取值
function Common_GetSDValue()
{
	var itmValue = '';

	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';	
    var className = $this.attr("class");
    try {
		if (className.indexOf('numberbox')>-1) {  	//时间框
			itmValue = $this.datetimebox('getValue');	
		}else if (className.indexOf('datebox')>-1) {  			//日期
			itmValue = $this.datebox('getValue');	    
		}else if (className.indexOf('datetimebox')>-1) {  	//时间框
			itmValue = $this.datetimebox('getValue');	
		}else if (className.indexOf('combobox')>-1) {  		//下拉框
		  	itmValue = $this.combobox('getValue');
		  	if (className.indexOf('mulcombox')>-1) {
		   		itmValue = $this.combobox('getValues').join(','); 	
		   	}
		}else if (className == 'switch') {  	//开关
			itmValue = $this.switchbox('getValue');	
		}else if (className == 'checkbox') {  	// 单个复选框
			itmValue = $this.checkbox('getValue');	    
		}else if (className == 'radio') {  		//单个单选框
			itmValue = $this.radio('getValue');
		}else if (className == 'searchbox') {  	//查询框框
			itmValue = $this.searchbox('getValue');	
		}else if (className == 'mullist') {   	//多选列表
			$('[name="'+arguments[0]+'"]').each(function(i, v){ 
				if (v.checked) {
					itmValue+=v.value+","
				}
			})	
			itmValue=itmValue.substr(0,itmValue.length-1)
		}else if (className == 'list') {   		//单选列表
			$('[name="'+arguments[0]+'"]').each(function(i, v){ 
				if (v.checked) {
					itmValue=v.value
				}
			})	
		}else{
			itmValue = $this.val();    
		}
    }catch(e) {
		itmValue = $this.val();        
	}
	return itmValue;	
}

function Common_CheckboxToSDDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMA.CPW.SDS.DictionarySrv",
		MethodName:"GetDicsByTypeCode",
		aQCID:objScreen.QCID,
		aVerID:objScreen.VerID,
		aTypeCode:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
	var len =dicList.length;		
	//当前填写窗口的宽=input宽-复选框宽度
	var listHtml=""
	var divWidth=$("input").width()-24;
	//获取默认字体大小，用以计算展现字典所需高度
	var style = document.body.currentStyle || document.defaultView.getComputedStyle(document.body, '')
    var dFontSize=style.fontSize.replace('px','');
	for (var index =0; index< len; index++) {
		var dicSubList = dicList[index].split(String.fromCharCode(2));	
		if (dicSubList[1]==undefined) continue;
		//计算一行能放置的字数
		var divWordCount=Math.floor(divWidth/dFontSize)
		var divheight=Math.ceil(dicSubList[1].length/divWordCount)*20
		listHtml +="<div style='padding-top:5px;height:"+divheight+"px;'>"; 
		//listHtml += " <div style='width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label=''  name="+ItemCode+"  value="+dicSubList[4]+' onCheckChange:function(event,value){objScreen.fireEvent('+ItemCode+',value)}'+"><span>"+dicSubList[1]+"</span></div>";  
		listHtml += "<input class='hisui-checkbox' value='"+dicSubList[4]+"' type='checkbox' data-options='onCheckChange:function(event,value){objScreen.fireEvent(\""+ItemCode+"\",\"\")}' style='display:inline-block;' label='"+dicSubList[1]+"'   name='"+ItemCode+"' id='"+ItemCode+dicSubList[0]+"'>"
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
}
//单选字典
function Common_RadioToSDDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var strDicList =$m({
		ClassName:"DHCMA.CPW.SDS.DictionarySrv",
		MethodName:"GetDicsByTypeCode",
		aQCID:objScreen.QCID,
		aVerID:objScreen.VerID,
		aTypeCode:DicType
	},false);
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
    var columns=len;
    if (len>3) columns=2;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div style='padding-top:5px;'>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			listHtml += "<div style='float:left;padding-right:10px;'>"
			listHtml += "<input class='hisui-radio' value='"+dicSubList[4]+"' type='radio' data-options='onChecked:function(event,value){objScreen.fireEvent(\""+ItemCode+"\",\"\")}' label='"+dicSubList[1]+"'   name='"+ItemCode+"' id='"+ItemCode+dicSubList[0]+"'>"
			listHtml += "</div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);
}
