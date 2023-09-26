 ///description:��������-�����������-���ϸ�ʾֵά��
var unitsUrl = 'dhcpha.comment.addfactor.save.csp';
Ext.onReady(function() {
	Ext.QuickTips.init();// ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var FactorAddButton = new Ext.Button({
         width : 65,
         id:"FactorAddBtn",
         text: '����',
         iconCls:"page_add",
         listeners:{
			 "click":function(){   
			 	FactorAddClick();
			 }   
         }
     })         
	var FactorUpdButton = new Ext.Button({
	     width : 65,
	     id:"FactorUpdBtn",
	     text: '�޸�',
	     iconCls:"page_modify",
	     listeners:{
		     "click":function(){
			     FactorUpdClick();
			 }   
	     }
	 })
     

	var FactorDelButton = new Ext.Button({
	     width : 65,
	     id:"FactorDelBtn",
	     text: 'ɾ��',
	     iconCls:"page_delete",
	     listeners:{
		     "click":function(){
			     FactorDelClick();
			  }  
	 	 }     
	 })
	var FactorDescField=new Ext.form.TextField({
	    width : 400, 
	    id:"FactorDescTxt",     
	    fieldLabel:"��ʾֵ" 
	})
	var Factorgridcm = new Ext.grid.ColumnModel({  
		columns:[       
			{header:'����',dataIndex:'facdesc',width:430},
			{header:'rowid',dataIndex:'facrowid',width:40,hidden:true}            
		]   
	});
    var Factorgridds = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
				url : unitsUrl
						+ '?action=QueryFactorDs',
				method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'facdesc',
            'facrowid'	    
		]),
        remoteSort: true
	});

 	var Factorgrid = new Ext.grid.GridPanel({ 
        id:'factortbl',
        title:'���ϸ�ʾֵά��',
        region:'center',
        width:650,
        autoScroll:true,
        enableHdMenu : false,
        ds: Factorgridds,
        cm: Factorgridcm,
        enableColumnMove : false,
        stripeRows: true,
		tbar:['����',FactorDescField,FactorAddButton,'-',FactorUpdButton],  
        trackMouseOver:'true'   
    });
    
	Factorgrid.on('rowclick',function(grid,rowIndex,e){
		var selectedRow = Factorgridds.data.items[rowIndex];
		var facdesc=selectedRow.data["facdesc"];
		Ext.getCmp("FactorDescTxt").setValue(facdesc);
	});    

	var por = new Ext.Viewport({
		layout : 'border', // ʹ��border����
		items : [Factorgrid]
	});
///-----------------------Events----------------------
	///����
	function FactorAddClick()
	{
		var facdesc=Ext.getCmp("FactorDescTxt").getValue();         
	    if (facdesc==""){
	       Ext.Msg.show({title:'��ʾ',msg:'����¼������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	       return;
	    } 
	    var repeatflag=CheckFactorRep(facdesc,"")    
	    if (repeatflag>0)
	    {
		    Ext.Msg.show({title:'��ʾ',msg:'���������'+repeatflag+'�м�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return
		} 
		Ext.getCmp("FactorDescTxt").setValue('')        	
		Ext.Ajax.request({
			url:unitsUrl+'?action=FactorAdd&FactorDesc='+facdesc ,
			waitMsg:'ɾ����...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
		  	        if (jsonData.retvalue==0) {
		  		       Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		  		       QueryFactorDs();
		  		}
		  		else{
		  		       Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: "+jsonData.retinfo);
		  		}
			},
			scope: this
		});
		
	}
   
 ///����
	function QueryFactorDs()
	{
		Factorgridds.removeAll(); 
		Factorgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryFactorDs' });
		Factorgridds.load({
		callback: function(r, options, success){
			if (success==false){
			     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
			     }
			}
		});
	}

	///�޸��¼�

	function FactorUpdClick()
	{
		var row = Ext.getCmp("factortbl").getSelectionModel().getSelections();  
		if (row.length == 0) {  
			Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;  
		}  	       
		var facrowid = row[0].data.facrowid;  //ԭ��ID       
		var facdesc=Ext.getCmp("FactorDescTxt").getValue();  //����
		if (facdesc=="") {
			Ext.Msg.show({title:'��ʾ',msg:'����¼������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		}
		var repeatflag=CheckFactorRep(facdesc,facrowid)    
	    if (repeatflag>0)
	    {
		    Ext.Msg.show({title:'��ʾ',msg:'���������'+repeatflag+'�м�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return
		} 
		Ext.Ajax.request({
			url:unitsUrl+'?action=FactorUpd&FactorDesc='+facdesc+'&FactorID='+facrowid ,
			waitMsg:'ɾ����...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
		  	        if (jsonData.retvalue==0) {
		  		       Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		  		       QueryFactorDs(); 
		  		}
		  		else{
		  		       Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: "+jsonData.retinfo);
	  		    
		  		}
			},
			scope: this
		});
	}
	///�޸�ԭ����¼�
	function FactorDelClick()
	{
		var row = Ext.getCmp("factortbl").getSelectionModel().getSelections();   	
		if (row.length == 0) {  	      
		Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;  
		}  
		Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ',DelClickResult);
	}
	///ɾ��ȷ�϶���
	function  DelClickResult(btn)
	{
		if (btn=="no"){ return ;}
		var row = Ext.getCmp("factortbl").getSelectionModel().getSelections(); 
		var facrowid = row[0].data.facrowid;  //ԭ��ID       
		///���ݿ⽻��ɾ��
		Ext.Ajax.request({
			url:unitsUrl+'?action=FactorDel&FactorID='+facrowid ,
			waitMsg:'ɾ����...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.retvalue==0) {
					Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					QueryFactorDs();
				}
				else{
					Ext.Msg.alert("��ʾ", "ɾ��ʧ��!����ֵ: "+jsonData.retinfo);
				}
			},
			scope: this
		});       
	}
	///�жϾ�ʾֵ�ظ�
	function CheckFactorRep(InputFactor,facrowid){
		var repflag="0"
		var Count = Factorgrid.getStore().getCount();
		for (var i = 0; i < Count; i++) {
			var rowData = Factorgridds.getAt(i);
			var rowFactor = rowData.get("facdesc");
			var rowid = rowData.get("facrowid");
			if ((InputFactor==rowFactor)&&(rowid!=facrowid)){
				repflag=i+1;
				return repflag;
			}
		}
		return repflag;
	}
});
