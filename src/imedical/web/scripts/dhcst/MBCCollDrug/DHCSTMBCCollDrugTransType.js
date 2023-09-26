
var unitsUrl = 'dhcst.mbccolldrugaction.csp';
var gParentId=""
//var NumberI='70' //�����ҩ״̬ת�� �Լ�ת����
Ext.onReady(function() {
       var gUserId = session['LOGON.USERID'];
	Ext.QuickTips.init();// ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var BarCode = new Ext.form.TextField({
		fieldLabel : '����',
		id : 'BarCode',
		name : 'BarCode',
		anchor : '90%',
		width : 140,
		listeners : {
			specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
			   MainGridDs.removeAll();
			    DecSaveCom();
		    }
		  }
		}
		
		});	
		// ���水ť
		var TransBT = new Ext.Toolbar.Button({
					id : "TransBT",
					text : 'ת��',
					tooltip : '���ת��',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
	                         transData();
						}
		          
		          })
function transData()
    {
            var rowData=MainGrid.getSelectionModel().getSelected();
			// ѡ����
			var JyCook = rowData.get("jycook");
			if(JyCook!="�Լ�"){
				Msg.info("warning", "�����Լ崦������ת��!");
				return;	
				}
		 Ext.MessageBox.show({
					title : '��ʾ',
					msg : '�Ƿ�ȷ��ת���ô���?',
					buttons : Ext.MessageBox.YESNO,
					fn : showResult,
					icon : Ext.MessageBox.QUESTION
				});
	}
			/**
		 * ת����ʾ
		 */
		function showResult(btn) {
			if (btn == "yes") {
                var rowData=MainGrid.getSelectionModel().getSelected();
				var prescno = rowData.get("Prescno");
				// ת����������
				var url =  unitsUrl+'?action=TransTypePresc&Prescno='
						+prescno+ "&UserId=" + gUserId;

				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : 'ת����...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", "ת���ɹ�!");
                                           MainGridDs.removeAll();
                                           MainGridDs.setBaseParam("Prescno",prescno)
                                           MainGridDs.load();
                                           PrintTransTypePresc(prescno);
								} else {
									var ret=jsonData.info;
									if(ret==-10){
										Msg.info("error", "���в�ҩ����������ת��!");
									}else if(ret==-20){
										Msg.info("error", "���Լ崦��������ת��!");
									}else{
										Msg.info("error", "ת��ʧ��!�������"+ret);
									}
								}
							},
							scope : this
						});
			}
		}
 function PrintTransTypePresc(PrescNo)
  {
	  	//1��׼����ӡ����
		//2��Excel
		var prtpath=GetPrintPath();
		var Template=prtpath+"YFcycfNew.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;
		var h=0;
		var startNo=2;
		//3����ӡ
        var tmlist=tkMakeServerCall("web.DHCST.DHCSTMBCCollDrug", "GetPrtPrescInfoDoc",PrescNo);
        
        var tmparr=tmlist.split("!!")
        var tmpmainstr=tmparr[0].split("^") //����Ϣ
        var paytype=tmpmainstr[32] //�ѱ�
        var doclocdesc=tmpmainstr[16] //�������
        var orddate=tmpmainstr[31] //��������
        var patname=tmpmainstr[1] //��������
        var patsex=tmpmainstr[3] //�����Ա�
        var patage=tmpmainstr[2] //��������
        var patno=tmpmainstr[0] //���ߵǼǺ�
        var diagnodesc=tmpmainstr[4] //���
        var factor=tmpmainstr[26] //����
        var CreatDoc=tmpmainstr[24] //�÷�
        var queinst=tmpmainstr[25] //�÷�
        var queqty=tmpmainstr[27] //����
		xlsheet.Cells(1, 1).Value ="(����)"
		xlsheet.Cells(1, 3).Value ="�׶�ҽ�ƴ�ѧ������������ҽԺ��ҩ��Ƭ��ҩ��";
		xlsheet.Cells(2, 8).Value= PrescNo    //����������
		xlsheet.Cells(3, 2).Value=doclocdesc
		xlsheet.Cells(3, 8).Value= "������:"+PrescNo    //������
		xlsheet.Cells(4, 2).Value =patname
		xlsheet.Cells(4, 8).Value ="�ǼǺ�:"+patno
        xlsheet.Cells(5, 3).Value =diagnodesc
	    var tmpdetailstr=tmparr[1].split("@") //����Ϣ  
	    var cnt=tmpdetailstr.length
	   for (i=0;i<cnt;i++)
		{
			
			var detaildata=tmpdetailstr[i].split("^")
			var indesc=detaildata[0] //ͨ����
			var dosagestr=detaildata[3] // ҩƷ����ȡ����������λ
			var qty=detaildata[1] // ҩƷ����
			var unit=detaildata[2] // ҩƷ��λ
			var price=detaildata[8]
			var remark=detaildata[13] // ҩƷ��ע
			var freq=detaildata[5]
			var BillSum=price*qty
			var Sum = BillSum + Sum
			i = i + 1
			if ((i%4)=='0')
			{
               var  Y = 8
               var  k = (i / 4) - 1
			} else
			{
               var k = parseInt(i / 4)
               var Y = 2 * (i%4 - 1) + 2
             }
              xlsheet.Cells(6 + 2 * k, Y).Value = indesc //'ҩƷ����
              xlsheet.Cells(6 + 2 * k + 1, Y + 1).Value = qty + unit    //'ҩƷ����ȡ����������λ
              xlsheet.Cells(6 + 2 * k, Y + 1).Value = remark    // '��ע

		} 
         xlsheet.Cells(20, 4).Value = "��" + factor + "��"
         xlsheet.Cells(20, 6).Value = " " + queinst + ", " +freq+",ÿ��"+queqty
         xlsheet.Cells(20, 9).Value = "����"
         xlsheet.Cells(21, 7).Value = "ҽʦǩ��(ǩ��)��" + CreatDoc
         //xlsheet.Cells(22, 1) = "������" + Format(Sum, "0.00") + "Ԫ"  //'�ϼ�
         xlsheet.Cells(22, 1).Value = "������" +Sum + "Ԫ"  //'�ϼ�
         xlsheet.Cells(1, 3).Value = "�׶�ҽ�ƴ�ѧ������������ҽԺ��ҩ��Ƭ��ҩ��"
         xlsheet.Cells(22, 1).Value = "����ѽ�" +factor * 3 + "Ԫ" //'�ϼ� 
         
		xlsheet.printout();
		SetNothing(xlApp,xlBook,xlsheet);
	  
	  }

//ɨ�豣��
function DecSaveCom(){
	var prescno=Ext.getCmp("BarCode").getValue();
	MainGridDs.removeAll();
	ChildGridDs.removeAll();
	MainGridDs.setBaseParam("Prescno",prescno)
	MainGridDs.load();
	Ext.getCmp("BarCode").setValue("");
	Ext.getCmp("BarCode").focus();
	}

	
   function addNewRow() {
	var record = Ext.data.Record.create([

                    {
			  name : 'PatLoc',
			  type : 'string'
			}, {
			  name : 'PatNo',
			  type : 'string'
			}, {
			  name : 'PatName',
			  type : 'string'
		       }, {
			  name : 'Prescno',
			  type : 'string'
			}, {
			  name : 'jycook',
			  type : 'string'
		       }
	]);
					
   }
    
    var MainGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetTransTypePresc',method:'GET'});
    var MainGridDs = new Ext.data.Store({
	proxy:MainGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [ 
		{name:'PatLoc'},
		{name:'PatNo'},
		{name:'PatName'},
		{name:'Prescno'},
		{name:'jycook'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //ģ��
    var MainGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'PatLoc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"�ǼǺ�",
        dataIndex:'PatNo',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"��������",
        dataIndex:'PatName',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"������",
        dataIndex:'Prescno',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"��ҩ��ʽ",
        dataIndex:'jycook',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    MainGrid = new Ext.grid.EditorGridPanel({
	store:MainGridDs,
	cm:MainGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true,
    tbar:[BarCode,"����",'-',TransBT],
	clicksToEdit:1
    });

    var ChildGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetOutPhaPrescDetail',method:'GET'});
    var ChildGridDs = new Ext.data.Store({
	proxy:ChildGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [{name:'DrugCode'},
		{name:'DrugDesc'},
		{name:'DrugQty'},
		{name:'DrugUom'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //ģ��
    var ChildGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"ҩƷ����",
        dataIndex:'DrugCode',
        width:100,
        align:'left',
        sortable:true
	 }, {
        header:"ҩƷ����",
        dataIndex:'DrugDesc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"ҩƷ����",
        dataIndex:'DrugQty',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"��λ",
        dataIndex:'DrugUom',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    ChildGrid = new Ext.grid.EditorGridPanel({
	store:ChildGridDs,
	cm:ChildGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true
    });    
 	// ��ӱ�񵥻����¼�
	MainGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var Prescno = MainGridDs.getAt(rowIndex).get("Prescno");
			ChildGridDs.setBaseParam('Prescno',Prescno)
			ChildGridDs.load();
		});
		
 	// ��ӱ��load�¼�
	MainGridDs.on('load', function() {
                       MainGrid.getSelectionModel().selectFirstRow();
                       MainGrid.getView().focusRow(0);
		});		
		
        
    var MainPanel = new Ext.Panel({
		title:'��������',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[MainGrid]                                 
	});        	  
        
    var ChildPanel = new Ext.Panel({
		title:'������ϸ',
		activeTab: 0,
		region:'south',
		height: 450,
		layout:'fit',
		items:[ChildGrid]                                 
	});  
	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����

				items : [MainPanel,ChildPanel]

			});

	    Ext.getCmp("BarCode").setValue("");
        Ext.getCmp("BarCode").focus();
});
