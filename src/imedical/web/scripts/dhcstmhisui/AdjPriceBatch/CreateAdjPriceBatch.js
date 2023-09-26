var init = function () {
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var Select=DetailGrid.getSelected();
				if(!isEmpty(Select)){
					param.Inci =Select.Inci;	
				}
				
			},
			onSelect:function(record){
				var rows =DetailGrid.getRows();  
				var row = rows[DetailGrid.editIndex];
				row.AspUomDesc=record.Description;
				//row.AspUomId=record.RowId;
				//��λ�л�����
				
				var NewUomid=record.RowId;
				var OldUomid=row.AspUomId;
				if(isEmpty(NewUomid)||(NewUomid==OldUomid)){return false;}
				var BUomId=row.BUomId;
				var PriorRpUom=row.PriorRpUom;
				var PriorSpUom=row.PriorSpUom;
				var ResultRpUom=row.ResultRpUom;
				var ResultSpUom=row.ResultSpUom;
                var confac=row.ConFacPur;
                if (NewUomid==BUomId){ //��ⵥλת��Ϊ������λ
                	row.PriorRpUom=Number(PriorRpUom).div(confac);
					row.PriorSpUom=Number(PriorSpUom).div(confac);
					row.ResultRpUom=Number(ResultRpUom).div(confac);
					row.ResultSpUom=Number(ResultSpUom).div(confac);
				}else{ //������λת��Ϊ��ⵥλ
					row.PriorRpUom=Number(PriorRpUom).mul(confac);
					row.PriorSpUom=Number(PriorSpUom).mul(confac);
					row.ResultRpUom=Number(ResultRpUom).mul(confac);
					row.ResultSpUom=Number(ResultSpUom).mul(confac);
				}
				
				row.DiffRpUom = accSub(row.ResultRpUom, row.PriorRpUom)
				row.DiffSpUom = accSub(row.ResultSpUom, row.PriorSpUom)
				row.AspUomId=NewUomid;
				//DetailGrid.refreshRow()	
				
			},
			onShowPanel:function(){
				$(this).combobox('reload');
			}
		}
	};
	var AdjReasonComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetAdjPriceReason',
		ResultSetType: 'array'
	},false);
	var AdjReasonCombox = {
		type: 'combobox',
		options: {
			data: AdjReasonComData,
			valueField: 'RowId',
			textField: 'Description',
			required:'Y'
		}
	};
	var InciHandlerParams = function () {
		var Scg = $("#ScgId").combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			BDPHospital:gHospId
		};
		return Obj;
	};
	$("#InciDesc").lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Query()
		}
	});
	function Query(){
		var ParamsObj=$UI.loopBlock('Conditions');
		ParamsObj=jQuery.extend(true,ParamsObj,{Status:"N"});
		if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
		if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!')
				return;
			}	
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatInfo',
			Params: Params,
			rows:99999
		});		
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearMain();
		}
	});
	var ClearMain=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var Dafult={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date())
			}
		$UI.fillBlock('#Conditions',Dafult);
		$('#ScgId').combotree('options')['setDefaultFun']();
		
	}
	var Save=function(){
	    var MainObj=$UI.loopBlock('#Conditions')
		var Main=JSON.stringify(MainObj)
		var Detail=DetailGrid.getChangesData('Incib');
		if(Detail===false){return}; //��֤δͨ��  ���ܱ���
		if (isEmpty(Detail)) {
			$UI.msg('alert','û����Ҫ����ĵ�����Ϣ!');
			return
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			MethodName: 'JsSave',
			Main: Main,
			Detail: JSON.stringify(Detail)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				var AdpNo=$("#AdjspNo").val()
				if (AdpNo==""){
                 $("#AdjspNo").val(jsonData.rowid); 
				}
				Query()
			}else{
					 $UI.msg('error',jsonData.msg);
				 }
		});	
		
	}
	var DetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true
		}, {
			title : "���۵���",
			field : 'AspNo',
			saveCol: true,
			width : 180
		}, {
			title: 'Incib',
			field: 'Incib',
			saveCol: true,
			hidden: true			
		}, {
			title: '����RowId',
			field: 'Inci',
			saveCol: true,
			hidden: true			
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width:100
		}, {
			title: '��������',
			field: 'InciDesc',
			editor: {type: 'validatebox',options: {required: true}},
			width: 180
		}, {
        	title: "���",
       		field:'Spec',
        	width:100
    	}, {
        	title: "����/Ч��",
       		field:'BatExp',
        	width:100
    	}, {
	        title:"���۵�λ",
	        field:'AspUomId',
	        width:100,
	        align:'right',
	        saveCol: true,
	        formatter: CommonFormatter(UomCombox,'AspUomId','AspUomDesc'),
	    	editor:UomCombox
	    },{
			title : "BUomId",
			field : 'BUomId',
			width : 100,
			hidden: true
		},{
			title : "ConFacPur",
			field : 'ConFacPur',
			width : 100,
			hidden : true
		}, {
	        title:"��ǰ�ۼ�",
	        field:'PriorSpUom',
	        saveCol: true,
	        width:100,
	        align:'right'
	    }, {
	        title:"��ǰ����",
	        field:'PriorRpUom',
	        saveCol: true,
	        width:100,
	        align:'right'
		}, {
	        title:"�������",
	        field:'ResultRpUom',
	        width:100,
	        align:'right',
	        saveCol: true,
	        editor: {
					type: 'numberbox',
					options: {
						required: true,
						min:0,
						precision:GetFmtNum('FmtPA')
					    }
				    }
	    }, {
	        title:"�����ۼ�",
	        field:'ResultSpUom',
	        width:100,
	        align:'right',
	        saveCol: true,
	        editor: {
					type: 'numberbox',
					options: {
						required: true,
						min:0,
						precision:GetFmtNum('FmtPA')
					    }
				    }
	    },{
	        title:"���(�ۼ�)",
	        field:'DiffSpUom',
	        width:100,
	        align:'right'
	    },{
	        title:"���(����)",
	        field:'DiffRpUom',
	        width:100,
	        align:'right'
	    },{
	        title:"����ۼ�",
	        field:'MaxSp',
	        width:100,
	        align:'right'
	    },{
	        title:"�ƻ���Ч����",
	        field:'PreExecuteDate',
	        width:120,
	        align:'left',
	        saveCol: true,
			editor:{type:'datebox',options:{}}
	    },{
	        title:"�Ƶ�����",
	        field:'AdjDate',
	        width:120,
	        align:'left'
	    },{
	        title:"ʵ����Ч����",
	        field:'ExecuteDate',
	        width:120,
	        align:'left'
	    },{
	        title:"��������",
	        field:'MarkTypeDesc',
	        width:120,
	        align:'left'
	    },{
	        title:"����ļ���",
	        field:'WarrentNo',
	        width:120,
	        align:'left',
	        saveCol: true,
	        editor:{type:'text',options:{}}
	    },{
	        title:"����ļ�����",
	        field:'WnoDate',
	        width:120,
	        align:'left',
	        saveCol: true,
	        editor:{type:'datebox',options:{}}
	    },{
	        title:"����ԭ��",
	        field:'AdjReasonId',
	        width:120,
	        align:'left',
	        saveCol: true,
			formatter: CommonFormatter(AdjReasonCombox,'AdjReasonId','AdjReason'),
	    	editor:AdjReasonCombox
	    },{
	        title:"������",
	        field:'AdjUserName',
	        width:100,
	        align:'left'
	    },{
	        title:"������",
	        field:'StkCatDesc',
	        width:100,
	        align:'left'	  
	    },{
	    	title : "��������",
		field : 'AdjSPCat',
	        saveCol: true,
		width : 100 //,hidden: true
	    }
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		url:$URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatInfo',
			rows:99999
		},
		deleteRowParams:{
			ClassName:'web.DHCSTMHUI.INAdjPriceBatch',
			MethodName:'jsDelete'
		},
		columns: DetailCm,
		sortName: 'RowId',  
		sortOrder: 'Desc',  
		showBar:true,
		pagination: false,
		showAddDelItems:true,
		toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					Save();
				}}],
		onClickCell: function(index, filed ,value){	
			DetailGrid.commonClickCell(index,filed,value);
		},
		onEndEdit:function(index, row, changes){
			var Editors = $(this).datagrid('getEditors', index);
		    for(var i=0;i<Editors.length;i++){
				var Editor = Editors[i];
				if(Editor.field=='ResultRpUom'){
					var ResultRpUom = row.ResultRpUom
					if (isEmpty(ResultRpUom)) {
						$UI.msg('alert','���۲���Ϊ��!');
						DetailGrid.checked=false;
						return false;
					}else if (ResultRpUom < 0) {
						$UI.msg('alert','���۲���С��0!');
						DetailGrid.checked=false;
						return false;
					}

					if (AdjSpBatchParamObj.CalSpByMarkType==1){
						var Inci = row.Inci
						var AspUomId = row.AspUomId
						var Sp = tkMakeServerCall("web.DHCSTMHUI.Common.PriceCommon","GetMtSp",Inci,AspUomId,ResultRpUom)
						if (Sp==0){
							$UI.msg('alert','�����ۼ�Ϊ0����������ʶ��������Ƿ���ȷ!');
							DetailGrid.checked=false;
							return false;
						}
						row.ResultSpUom = Sp
					}
					var ResultSpUom = row.ResultSpUom
					var PriorRpUom = row.PriorRpUom
					row.DiffRpUom = accSub(ResultRpUom, PriorRpUom)
					
					
				}else if(Editor.field=='ResultSpUom'){
					var ResultSpUom = row.ResultSpUom
					var ResultRpUom = row.ResultRpUom
					var PriorSpUom = row.PriorSpUom
					if (ResultSpUom < 0) {
						$UI.msg('alert','�ۼ۲���С��0!');
						DetailGrid.checked=false;
						return false;
					}
					var PriorRpUom = row.PriorRpUom
					row.DiffSpUom = accSub(ResultSpUom, PriorSpUom)
					
					
				}
				
		    }
		},
		onBeginEdit: function(index, row){
			if(row.AspNo!=""){
			 $("#AdjspNo").val(row.AspNo); 
			}
			
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == "InciDesc"){
					$(e.target).bind("keydown", function(event){
						if(event.keyCode == 13){
							var Input = $(this).val();
							var ScgId = $("#ScgId").combotree('getValue');
							var Locdr = gLocId
							var ParamsObj={StkGrpRowId:ScgId,StkGrpType:"M",Locdr:Locdr,NotUseFlag:"",QtyFlag:"Y",
		                    ToLoc:'',ReqModeLimited:"",NoLocReq:"",HV:"",RequestNoStock:"Y"};	
							IncItmBatWindowAll(Input, ParamsObj, ReturnInfoFunc);
						}
					});
				}	
			}
		},
		beforeAddFn:function(){
			/*
			if(isEmpty($HUI.combobox("#ScgId").getValue())){
				$UI.msg('alert','���鲻��Ϊ��!');
				return false;
			};	*/	
		}
	})
	
	function ReturnInfoFunc(rows){
		rows = [].concat(rows);
		var length=rows.length
		$.each(rows, function(index, row){
			var RowData = DetailGrid.getSelected();
			RowData.Incib = row.Incib;
			RowData.Inci = row.InciDr;
			RowData.InciCode = row.InciCode;
			RowData.InciDesc = row.InciDesc
			RowData.Spec = row.Spec;
			RowData.BatExp = row.BatExp;
			RowData.AspUomId=row.PurUomId   
            RowData.AspUomDesc=row.PurUomDesc
            RowData.PriorSpUom=row.Sp
            RowData.PriorRpUom=row.Rp
			RowData.ResultRpUom=row.ResultRp
            RowData.ResultSpUom=row.ResultBatSp
            RowData.AdjReasonId=row.AdjReasonId
            RowData.AdjSPCat="�ֶ�����";
            var ParamsObj=$UI.loopBlock('Conditions');
            var Params = JSON.stringify(ParamsObj);
            /*$.cm({
			    ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			    MethodName: 'GetItmInfo',
			    Inci: row.InciDr,
				Params:Params
	 		},
	 		function(jsonData){
			RowData.ConFacPur=jsonData.ConFacPur
			
        	if ((jsonData.PurSp!=0)&&(jsonData.PurRp!=0)){
			 	var margin = accDiv(jsonData.PurSp, jsonData.PurRp);
				SelectRow.MarginNow=margin.toFixed(3);
	        }
			
            RowData.MaxSp=jsonData.MaxSp
            RowData.MarkTypeDesc=jsonData.MarkTypeDesc
            RowData.StkCatDesc=jsonData.StkCatDesc
            RowData.WarrentNo=jsonData.WarrentNo
            RowData.WnoDate=jsonData.WnoDate     
            var Today = DateFormatter(new Date())
            var Tomorrow = DateFormatter(DateAdd(new Date(), 'd', 1))
		    RowData.AdjDate=Today
		    RowData.PreExecuteDate=Tomorrow
			DetailGrid.refreshRow()
		    }); */
            var jsonData=$.cm({
	 			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			    MethodName: 'GetItmInfo',
			    Inci: row.InciDr,
				Params:Params	
	 		},false)
	 		RowData.ConFacPur=jsonData.ConFacPur
	 		RowData.MaxSp=jsonData.MaxSp
            RowData.MarkTypeDesc=jsonData.MarkTypeDesc
            RowData.StkCatDesc=jsonData.StkCatDesc
            RowData.WarrentNo=jsonData.WarrentNo
            RowData.WnoDate=jsonData.WnoDate     
            var Today = DateFormatter(new Date())
            var Tomorrow = DateFormatter(DateAdd(new Date(), 'd', 1))
		    RowData.AdjDate=Today
		    RowData.PreExecuteDate=Tomorrow
			DetailGrid.refreshRow()
			if(length>(index+1)){
				DetailGrid.commonAddRow()
			}
			
		});
	}
	//����ȱʡֵ
	ClearMain();
}
$(init);