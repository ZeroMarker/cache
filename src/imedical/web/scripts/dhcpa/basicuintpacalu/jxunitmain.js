//����
var AdjustButton = new Ext.Toolbar.Button({
   	        text : '���ݱ���',
			iconCls : 'option',
			handler : function() {
			afterEdit(jxunitGrid);
		}
  });	 
var jxunitGrid = new dhc.herp.jxunitGrid({
            title:'����ָ�����ݵ���',
		    region: 'center',
			height:450,
		    url: 'dhc.pa.basicuintpacaluexe.csp',
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
					    var rowObj = itemGrid.getSelectionModel().getSelections();
						var curstate = rowObj[0].get("auditstate");
						
		                var record = grid.getStore().getAt(rowIndex);
						if (((curstate=="δ�ύ")||(curstate==0))&&((columnIndex==12)||(columnIndex==11)||(columnIndex==1))){
							var cl1 = grid.getColumnModel().getIndexById("Rscore");							  
							var cl2 = grid.getColumnModel().getIndexById("estdesc");
							//alert(cl2);
							grid.getColumnModel().setEditable(cl1,true);
							grid.getColumnModel().setEditable(cl2,true);
							return true;
						 } else {
							 Ext.Msg.show({title:'����',msg:'���в��ܽ����޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							 return false;
						 }
						
						
						/*if (record.data.iscolType== 1)  //�Ǽ�����ָ��--��ʱ�����Ա༭
						{
						//	alert(columnIndex);
							if (((curstate=="δ�ύ")||(curstate==0))&&((columnIndex==12)||(columnIndex==11))) {
								  var cl1 = grid.getColumnModel().getIndexById("Rscore");							  
								  var cl2 = grid.getColumnModel().getIndexById("estdesc");
								  //alert(cl2);
								  grid.getColumnModel().setEditable(cl1,true);
								  grid.getColumnModel().setEditable(cl2,true);
								  return true;
							 } else {
							 Ext.Msg.show({title:'����',msg:'���в��ܽ����޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							 return false;
							 }
						 }else{  //������ָ��  --�������Ա༭
						    if((curstate=="δ�ύ")||(curstate==0)){
								if ((columnIndex==12)||(columnIndex==11)) {
								  var cl3 = grid.getColumnModel().getIndexById("estdesc");
								  var c14 = grid.getColumnModel().getIndexById("Rscore");
								  grid.getColumnModel().setEditable(cl3,true);
								  grid.getColumnModel().setEditable(cl4,true);
								  return true;
								 }
								 if(columnIndex==9){
									kpiconfirm(record.data.urperiod,record.data.urdeptname,record.data.kpiname,periodTypeField.getValue())
								 }else{
									Ext.Msg.show({title:'����',msg:'���в��ܽ����޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								 }
						   }
					   }*/
					}
            },
			fields : [
			       new Ext.grid.CheckboxSelectionModel({hidden : false,editable:false}),
			       {
						header : '���˼�¼����ID',
						dataIndex : 'mainrowid',
						editable:false,
						hidden : true
					},{
						header : '���˼�¼��ϸ��ID',
						dataIndex : 'detailrowid',
						editable:false,
						hidden : true
					},  {
						id : 'urperiod',
						header : '������',
						editable:false,
						width : 80,
						dataIndex : 'urperiod'

					},{
						id : 'urdeptname',
						header : '��������',
						editable:false,
						width : 100,
						dataIndex : 'urdeptname'

					},{
						id : 'iscolType',
						header : '�Ƿ������ָ��',
						width : 150,
						editable:false,
						hidden:true,
						dataIndex : 'iscolType'

					},{
						id : 'kpiname',
						header : 'ָ������',
						width : 150,
						editable:false,
						dataIndex : 'kpiname'

					},{
						id : 'targetvalue',
						header : 'Ŀ��ֵ',
						editable:false,
						align:'right',
						width : 80,
						dataIndex : 'targetvalue'

					}, {
						id : 'actvalue',
						header : 'ʵ��ֵ',
						editable:false,
						align:'right',
						width : 80,
						dataIndex : 'actvalue'
					},{
						id : 'score',
						header : '���˷�',
						editable:false,
						width : 80,
						align:'right',
						dataIndex : 'score'
					},{
						id : 'Rscore',
						header : '���տ��˷�',
						editable:false,
						width : 80,
						align:'right',
						dataIndex : 'Rscore'
					},
					{
						id : 'estdesc',
						header : '��������',
						editable:false,
						width : 80,
						dataIndex : 'estdesc'

					},{
						id : 'detailinfo',
						header : '��ϸ',
						editable:false,
						width : 80,
						hidden:true,
						dataIndex : 'detailinfo'
					}, {
						id : 'ratedvalue',
						header : '��Ȩ��÷�',
						editable:false,
						align:'right',
						width : 80,
						dataIndex : 'ratedvalue'
					},{
						id : 'methodname',
						header : '���˷���',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'methodname'
					}],
                    tbar:[]					
		});
/**
    jxunitGrid.btnAddHide();  //�������Ӱ�ť
   	jxunitGrid.btnSaveHide();  //���ر��水ť
    jxunitGrid.btnDeleteHide(); //����ɾ����ť
    jxunitGrid.btnResetHide();  //�������ð�ť
    jxunitGrid.btnPrintHide();  //���ش�ӡ��ť
	
    jxunitGrid.hiddenButton(1);
    jxunitGrid.hiddenButton(2);
	jxunitGrid.hiddenButton(3);
**/
function kpiconfirm(period,deptname,kpiname,periodType)
{
   Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ�޸ĸ��ڼ�ָ�ꣿ', function(btn){
    if (btn == 'yes'){
	    
        window.open("dhc.pa.basicuintpacaludetail.csp?start=0&limit=20&period="+period+"&deptdr="+deptname+"&kpidrs="+kpiname+"&periodType="+periodType+"&userID="+userdr, "", "toolbar=no,height=500,width=800");
        //window.open("dhc.pa.basicuintpacaludetail.csp?start=0&limit=20&period=201501&periodType=Q&userID="+userdr, "", "toolbar=no,height=500,width=800");

    }
});
   
}


function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼� 
		var rowObj = jxunitGrid.getSelectionModel().getSelections();
		
			var schemObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�������ݵļ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			  var curstate=schemObj[i].get("auditstate");
			  if (curstate!="δ�ύ")
			  {
				Ext.Msg.show({title:'����',msg:curstate+'���ܽ����޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			  }
			else{ //encodeURIComponent(rowObj[i].get("estdesc"))
			      // alert(encodeURIComponent(rowObj[i].get("estdesc")));
				  var para='dhc.pa.basicuintpacaluexe.csp?action=updateNew&mainrowid='+rowObj[i].get("mainrowid")+'&detailrowid='+rowObj[i].get("detailrowid")+'&period='+rowObj[i].get("urperiod")+'&periodType='+periodTypeField.getValue()+'&userID='+userdr+'&Rscore='+rowObj[i].get("Rscore")+"&desc="+encodeURIComponent(rowObj[i].get("estdesc"));
				  
				   Ext.Ajax.request({
					url:para,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						console.log(result);
						var jsonData = Ext.util.JSON.decode(result.responseText);
						//alert(result.responseText);
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'ע��',msg:'���ݱ���ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								jxunitGrid.load({params:{start:0, limit:25}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:'���ݱ���ʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
			 
			}
			jxunitGrid.getStore().reload();
			}
		   }
	 
}
jxunitGrid.on("afteredit", afterEdit, jxunitGrid);   
