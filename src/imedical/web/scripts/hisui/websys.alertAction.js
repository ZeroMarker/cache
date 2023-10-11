$(function(){
	var singleShowTypeData = [{val:"S",txt:"������ʾ"},{val:"M",txt:"�ϲ���ʾ"}];
	$("#grplu").lookup({
		url:$URL+"?ClassName=web.SSGroup&QueryName=Find&desc=",
		mode:'remote',
		isCombo:true,
		minQueryLen:1,
		idField:'ID',
		textField:'SSGRPDesc',
		columns:[[  
			{field:'SSGRPDesc',title:'��ȫ������',width:200},  
			{field:'ID',title:'��ȫ��ID',width:100}
		]],
		pagination:true,
		showPageList:false,
		onBeforeLoad:function(param){
			param.desc=param.q;
		}
	});
	$('#Find').click(function(){
		if (!$(this).linkbutton('options').disabled){
			$('#alertGrid').datagrid('load');
		}
	});
	$("#OpenCfgBtn").click(function(){
		$("#cfgWin").show().window({
			title:"������������",
			collapsible:false,
			minimizable:false,
			maximizable:false,
			closable:true,
			width:400,height:200,
			iconCls:'icon-w-config',
			modal:true
		}).window('open');
	});
	$("#SaveCfg").click(function(){
		var rollTimeVal = getValueById("rollTime");
		var defPos = getValueById("defaultPosition");
		$cm({ClassName:"CF.BSP.MSG.DTO.AlertAction",MethodName:"SaveCfg","dto.rollTime":rollTimeVal,"dto.defaultPosition":defPos},function(rtn){
			if(rtn.success==1){
				$("#cfgWin").window('close');
				$.messager.popover({msg:rtn.msg,type:'success'});
			}else{
				$.messager.popover({msg:rtn.msg,type:'error'});
			}
		});
	});
	if ($('#alertGrid').length>0) {
		$('#alertGrid').mgrid({
			className:'CF.BSP.MSG.DTO.AlertAction',
			key:'alert',
			codeField:'TCode',
			editGrid:true,
			title:'',border:false,pagination:false,
			fit:true,
			bodyCls:'panel-body-gray',
			fitColumns:false,
			autoSizeColumn:true,
			rownumbers:true,
			showPageList:false,
			singleSelect:true,
			queryParams:{ClassName:"CF.BSP.MSG.DTO.AlertAction",QueryName:"LookUp",Code:getValueById("Code"),Caption:getValueById("Caption")},
			onBeforeLoad:function(param){
				param.Code=getValueById("Code");
				param.Caption=getValueById("Caption");
				param.GrpDesc=getValueById("grplu");
			},
			url:$URL,
			titleNoWrap:false,/*��ͷ�Զ�����*/
			columns:[
				[
				{"field":"TID","title":"TID","align":"left",hidden:true},
				{"field":"TCode","title":"����",width:100,editor:{type:'text'}},
				{"field":"TCaption","title":"����",width:100,editor:{type:'text'}},
				{"field":"TQueryName","title":"����Query",width:350,editor:{type:'text'}},
				{"field":"TAlertTitle","title":"��ʾ����",width:280,editor:{type:'text'}},
				{"field":"TOpenWidth","title":"����������",width:50,editor:{type:'text'}},
				{"field":"TOpenHeight","title":"��������߶�",width:50,editor:{type:'text'}},
				{"field":"TIsShowClose","title":"��ʾ�رհ�ť",width:50,"editor":{"type":"checkbox","options":{"on":"1","off":"0"}}},
				{"field":"TSeq","title":"˳��",width:50,"editor":{"type":"text"}},
				{"field":"TBGColor","title":"����ɫ",width:80,"editor":{
						"type":"combobox",
						options:{
							valueField:'val',
							textField:'txt',
							panelHeight:'auto',
							data:[{val:'red',txt:'red'},
							{val:'blue',txt:'blue'},
							{val:'yellow',txt:'yellow'},
							{val:'green',txt:'green'},
							{val:'violet',txt:'violet'},
							{val:'cyan',txt:'cyan'},
							{val:'pured',txt:'pured'}]
						}
					}
				},
				{"field":"TSingleShow","title":"�Ƿ񵥶���ʾ",width:80,
					"editor":{
						"type":"combobox","options":{
							valueField:'val',
							textField:'txt',
							data:singleShowTypeData
						}
					},formatter:function(v){
						for (var i=0; i<singleShowTypeData.length;i++){
							if (singleShowTypeData[i].val==v) return singleShowTypeData[i].txt;
						}
					}
				},
				{"field":"TActive","title":"����",width:50,"editor":{"type":"checkbox","options":{"on":"1","off":"0"}}},
				{"field":"TGroupDesc","title":"��ȫ��",width:200,"align":"left",
					"editor":{
						"type":"combobox",
						options:{
							url:$URL+"?ClassName=web.SSGroup&QueryName=Find&ResultSetType=array&desc=&rows=10000",
							valueField:'SSGRPDesc',
							textField:'SSGRPDesc',
							multiple:true,
							rowStyle:"checkbox",
							selectOnNavigation:false,
							//data:allGroupData.rows
						}
					},
					formatter:function(v){
						if (v=="") return "���а�ȫ��ɼ�";
						return v;
					}
				}
				
				,{"field":"TAudioName","title":"��Ƶ�ļ�",width:100,"editor":{"type":"text"}}
				
				]],
			insOrUpdHandler:function(row){
				var param ;
				if (row.TID==""){
					if (!row.TCaption){
						$.messager.popover({msg:'��������Ϊ�գ�',type:'info'});
						return ;
					}
					param = this.insReq;
				}else{
					param = $.extend(this.updReq,{
						"dto.alert.id":row.TID
					});
				}
				$.extend(param,{
					"dto.alert.Code":row.TCode,
					"dto.alert.Caption":row.TCaption,
					"dto.alert.QueryName":row.TQueryName,
					"dto.alert.AlertTitle":row.TAlertTitle,
					"dto.alert.OpenWidth":row.TOpenWidth,
					"dto.alert.OpenHeight":row.TOpenHeight,
					"dto.alert.IsShowClose":row.TIsShowClose,
					"dto.alert.Seq":row.TSeq,
					"dto.alert.BGColor":row.TBGColor,
					"dto.alert.SingleShow":row.TSingleShow,
					"dto.alert.Active":row.TActive,
					"dto.alert.GroupDesc":row.TGroupDesc
					,"dto.alert.AudioName":row.TAudioName
				});
				$cm(param,defaultCallBack);
			},
			getNewRecord:function(){
				return {TID:"",TCode:"",TCaption:"",TQueryName:"",TAlertTitle:"",TOpenWidth:"",TOpenHeight:"",TIsShowClose:"",TSeq:"",TBGColor:"",TSingleShow:"", TActive:"",TGroupDesc:""};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("ɾ��", "�ò�����ͬ�ָ�,ȷ��ɾ����"+row.TCaption+"������?", function (r) {
					if (r) {
						$.extend(_t.delReq,{"dto.alertId":row.TID});
						$cm(_t.delReq,defaultCallBack);
					}
				});
			}
		}); //.datagrid('loadData',data);
	}
})
