var init = function() {
var EpisodeId="";
var IncCode="";
/*��ť�¼�*/
/*--��ѯ--*/
	$UI.linkbutton('#SearchBT', {
		onClick: function () {
			ComSearch(Select);
		}
	});
	var Select = function (ComRowid,RetStatus) {
		ComMainGrid.load({
			ClassName: 'web.DHCSTMHUI.Comment',
			QueryName: 'QueryDetail',
			Parref: ComRowid,
			RetStatus:RetStatus
		});
	}
	
	var ComMainCm = [[{
			title:"������ϸid",
			field:'RowId',
			width:100,
			hidden:true
		}, {
			title:"���ʴ���",
			field:'InciCode',
			width:100,
			hidden:true
		}, {
			title:"��ֵҽ����ȡ��id",
			field:'ORIRowId',
			width:100,
			hidden:true
		}, {
			title:"ҽ��ID",
			field:'Oeori',
			hidden:true
		}, {
			title:"��������",
			field:'ComNo',
			width:200,
			hidden:true
		}, {
			title:"ҽ������",
			field:'Arcim',
			width:180
		}, {
			title:"��ֵ����",
			field:'Barcode',
			width:120
		}, {
			title:"�������",
			field:'CurRet',
			width:80,
	        formatter: function(value,row,index){
				if (row.CurRet==0){
					return "������";
				} else if(row.CurRet==1){
					return "����";
				}else if(row.CurRet==2){
					return "������"
				}else if(row.CurRet==3){
					return "�ѽ���"
				}else if(row.CurRet==4){
					return "δ����"
				}else {
					return ""
				
				}
			}
		}, {
			title:"���",
			field:'Spec',
			width:80
		}, {
			title:"����",
			field:'OeoriNum',
			width:40
		}, {
			title:"��λ",
			field:'OeoriUom',
			width:50
		}, {
			title:"��������",
			field:'OeoriLoc',
			width:150
		}, {
			title:"����ҽ��",
			field:'OeoriDoctor',
			width:100
		}, {
			title:"ҽ������",
			field:'OeoriDate',
			width:100
		}, {
			title:"ҽ��ʱ��",
			field:'OeoriTime',
			width:100
		}, {
			title:"���տ���",
			field:'OeoriRecLoc',
			width:150
		}, {
			title:"Adm",
			field:'Adm',
			width:100,
			hidden:true
		}
	]];	
	var ComMainGrid = $UI.datagrid('#ComMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Comment',
			QueryName: 'QueryDetail'
		},
		onClickCell: function(index, filed ,value){	
			ComMainGrid.commonClickCell(index,filed,value)
		},
		columns: ComMainCm,
		toolbar: '#ComMainTB',
		onClickRow:function(index, row){
			//���߻�����Ϣ
			$("#Patinfo").empty();
			EpisodeId=row.Adm;
			IncCode=row.InciCode;
			var ArrData = $.cm({
				ClassName: 'web.DHCSTMHUI.Comment',
				MethodName: 'GetPaInfo',
				adm: EpisodeId
			}, false);
			var patordinfo='';
			var patId=ArrData.papmidr;
			var patNo=ArrData.patNo;
			var patName=ArrData.patName;
			var imageid="";
			var sexDesc=ArrData.sexDesc;	//�Ա�
			if (sexDesc=="Ů"){	
				imageid="icon-female.png";
			}else if (sexDesc=="��"){
				imageid="icon-male.png";
			}else{
				imageid="icon-unmale.png";
			}
			var patAge=ArrData.patAge;
			
			var depdesc=ArrData.depdesc;
			var patDiag ="��ϣ�"+ ArrData.diag;	//���
			patordinfo=patordinfo+'<span>'+patNo+'&nbsp;&nbsp;</span>|&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+sexDesc+'&nbsp;&nbsp;</span>|&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+patAge+'&nbsp;&nbsp;</span>|&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+depdesc+'&nbsp;&nbsp;</span>|&nbsp;&nbsp;';
			var pathtml=' <div class="col-md-12" id="patInfo"><div style="margin-left:10px;">'+
				'<a href="#" class="thumbnail" style="border:0px;height:20px;">'+
				'<img src=/dthealth/web/scripts/dhcstmhisui/Common/images/'+imageid+' style="border-radius:35px;height:50px;width:50px;">'+
				'</a>'+	
                '</div>'+
				' <div style="margin-left:70px;margin-top:-40px;">'+				
				' <span style="font-size:17px;">'+patName+'&nbsp;&nbsp;&nbsp;</span>'+
				patordinfo+
				' </div></div>'			
			var pathtml=pathtml+'<div style="margin-top:10px;margin-left:60px;">'+' <span>&nbsp;&nbsp;&nbsp;'+patDiag+'</span>'+' </div>'
			$("#Patinfo").append(pathtml);
			var tab = $('#tabsForm').tabs('getSelected');
			var index = $('#tabsForm').tabs('getTabIndex',tab);
			if (index==0){	//������¼
				$('#ifrmAllergy').attr('src', 'dhcem.allergyenter.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);		
			}else if (index==1){	//����¼
				$('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);			
			}else if (index==2){	//�����¼
				$('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp'+'?EpisodeID=' + EpisodeId+'&NoReaded='+'1'+'&PatientID='+patId);			
			}else if (index==3){	//�������
				 $('#ifrmEMR').attr('src', 'emr.browse.csp'+ '?EpisodeID=' + EpisodeId);			
			}else if (index==4){	//����ҽ��
				$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp'+'?EpisodeID=' + EpisodeId+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');		
			}else if (index==5){	//�����¼
				$('#ifrmConQuery').attr('src', 'dhcem.consultpathis.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);		
			}else if (index==6){	//˵����
				//http://172.0.0.1/dthealth/web/csp/dhc.bdp.kb.dhcmatbrowser.csp&GenCode=&PointerCode=
				$('#ifrmInstruction').attr('src', 'ddhc.bdp.kb.dhcmatbrowser.csp'+'?GenCode=' + InciCode);		
			}
			
			
			
		}
	});
	$HUI.tabs("#tabsForm",{
		onSelect:function(title,index){
			var ArrData=tkMakeServerCall("web.DHCSTMHUI.Comment","GetPaInfo",EpisodeId);
		    var patId=ArrData.papmidr;	
	        if (title=="�������"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
                    $('#ifrmEMR').attr('src', 'emr.browse.csp'+ '?EpisodeID=' + EpisodeId);
		        } 
		    }else if (title=="������¼"){
			    if ($('#ifrmAllergy').attr('src')==""||"undefined"){
					$('#ifrmAllergy').attr('src', 'dhcem.allergyenter.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId); 
			    }
			}else if (title=="����¼"){
				if ($('#ifrmRisQuery').attr('src')==""||"undefined"){
					$('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);
				}
			}else if (title=="�����¼"){
				if ($('#ifrmLisQuery').attr('src')==""||"undefined"){
					$('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp'+'?EpisodeID=' + EpisodeId+'&NoReaded='+'1'+'&PatientID='+patId); 
				}
			}else if (title=="����ҽ��"){
				if ($('#ifrmOrdQuery').attr('src')==""||"undefined"){
					$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp'+'?EpisodeID=' + EpisodeId+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
					//$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?EpisodeID=' + EpisodeId);
				} 
			}else if (title=="�����¼"){
				if ($('#ifrmConQuery').attr('src')==""||"undefined"){
					$('#ifrmConQuery').attr('src', 'dhcem.consultpathis.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);				
				}
			}else if (title=="˵����"){
				alert(IncCode)
				if ($('#ifrmInstruction').attr('src')==""||"undefined"){
					$('#ifrmInstruction').attr('src', 'ddhc.bdp.kb.dhcmatbrowser.csp'+'?GenCode=' + IncCode);
				}
			}
			
		}
	});	
/*--��������--*/
	$UI.linkbutton('#PassBT', {
		onClick: function () {
			var Row=ComMainGrid.getSelected();
			if ((isEmpty(Row)) || (Row.length == 0)) {
				$UI.msg('alert', '��ѡ����Ҫ������ҽ����ϸ!');
				return false;
			}
			var DetailId=Row.RowId;
			var Params = JSON.stringify(addSessionParams({
				Result: "Y"
			}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.Comment',
				MethodName: 'SaveLogItm',
				DetailId:DetailId,
				Params:Params
			},function(jsonData){
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var ComRowid= jsonData.rowid;
					Select(ComRowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
/*--����������--*/
	$UI.linkbutton('#RefuseBT', {
		onClick: function () {
			var Row=ComMainGrid.getSelected();
			if ((isEmpty(Row)) || (Row.length == 0)) {
				$UI.msg('alert', '��ѡ����Ҫ������ҽ����ϸ!');
				return false;
			}
			var DetailId=Row.RowId;
			ComRefuse(DetailId,Select);
		}
	});	
/*--������־--*/	
		$UI.linkbutton('#LogBT', {
		onClick: function () {
			var Row=ComMainGrid.getSelected();
			if ((isEmpty(Row)) || (Row.length == 0)) {
				$UI.msg('alert', '��ѡ��ҽ����ϸ!');
				return false;
			}
			var DetailId=Row.RowId;
			ComLogSearch(DetailId);
		}
	});	
	
}
$(init);