 ///description:处方点评-点评相关配置-不合格警示值维护
var unitsUrl = 'dhcpha.comment.addfactor.save.csp';
Ext.onReady(function() {
	Ext.QuickTips.init();// 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var FactorAddButton = new Ext.Button({
         width : 65,
         id:"FactorAddBtn",
         text: '增加',
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
	     text: '修改',
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
	     text: '删除',
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
	    fieldLabel:"警示值" 
	})
	var Factorgridcm = new Ext.grid.ColumnModel({  
		columns:[       
			{header:'描述',dataIndex:'facdesc',width:430},
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
        title:'不合格警示值维护',
        region:'center',
        width:650,
        autoScroll:true,
        enableHdMenu : false,
        ds: Factorgridds,
        cm: Factorgridcm,
        enableColumnMove : false,
        stripeRows: true,
		tbar:['描述',FactorDescField,FactorAddButton,'-',FactorUpdButton],  
        trackMouseOver:'true'   
    });
    
	Factorgrid.on('rowclick',function(grid,rowIndex,e){
		var selectedRow = Factorgridds.data.items[rowIndex];
		var facdesc=selectedRow.data["facdesc"];
		Ext.getCmp("FactorDescTxt").setValue(facdesc);
	});    

	var por = new Ext.Viewport({
		layout : 'border', // 使用border布局
		items : [Factorgrid]
	});
///-----------------------Events----------------------
	///增加
	function FactorAddClick()
	{
		var facdesc=Ext.getCmp("FactorDescTxt").getValue();         
	    if (facdesc==""){
	       Ext.Msg.show({title:'提示',msg:'请先录入描述!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	       return;
	    } 
	    var repeatflag=CheckFactorRep(facdesc,"")    
	    if (repeatflag>0)
	    {
		    Ext.Msg.show({title:'提示',msg:'该描述与第'+repeatflag+'行记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return
		} 
		Ext.getCmp("FactorDescTxt").setValue('')        	
		Ext.Ajax.request({
			url:unitsUrl+'?action=FactorAdd&FactorDesc='+facdesc ,
			waitMsg:'删除中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
		  	        if (jsonData.retvalue==0) {
		  		       Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		  		       QueryFactorDs();
		  		}
		  		else{
		  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
		  		}
			},
			scope: this
		});
		
	}
   
 ///查找
	function QueryFactorDs()
	{
		Factorgridds.removeAll(); 
		Factorgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryFactorDs' });
		Factorgridds.load({
		callback: function(r, options, success){
			if (success==false){
			     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
			     }
			}
		});
	}

	///修改事件

	function FactorUpdClick()
	{
		var row = Ext.getCmp("factortbl").getSelectionModel().getSelections();  
		if (row.length == 0) {  
			Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;  
		}  	       
		var facrowid = row[0].data.facrowid;  //原因ID       
		var facdesc=Ext.getCmp("FactorDescTxt").getValue();  //描述
		if (facdesc=="") {
			Ext.Msg.show({title:'提示',msg:'请先录入描述!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		}
		var repeatflag=CheckFactorRep(facdesc,facrowid)    
	    if (repeatflag>0)
	    {
		    Ext.Msg.show({title:'提示',msg:'该描述与第'+repeatflag+'行记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return
		} 
		Ext.Ajax.request({
			url:unitsUrl+'?action=FactorUpd&FactorDesc='+facdesc+'&FactorID='+facrowid ,
			waitMsg:'删除中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
		  	        if (jsonData.retvalue==0) {
		  		       Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		  		       QueryFactorDs(); 
		  		}
		  		else{
		  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
	  		    
		  		}
			},
			scope: this
		});
	}
	///修改原因的事件
	function FactorDelClick()
	{
		var row = Ext.getCmp("factortbl").getSelectionModel().getSelections();   	
		if (row.length == 0) {  	      
		Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;  
		}  
		Ext.MessageBox.confirm('注意', '确认要删除吗 ? ',DelClickResult);
	}
	///删除确认动作
	function  DelClickResult(btn)
	{
		if (btn=="no"){ return ;}
		var row = Ext.getCmp("factortbl").getSelectionModel().getSelections(); 
		var facrowid = row[0].data.facrowid;  //原因ID       
		///数据库交互删除
		Ext.Ajax.request({
			url:unitsUrl+'?action=FactorDel&FactorID='+facrowid ,
			waitMsg:'删除中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.retvalue==0) {
					Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					QueryFactorDs();
				}
				else{
					Ext.Msg.alert("提示", "删除失败!返回值: "+jsonData.retinfo);
				}
			},
			scope: this
		});       
	}
	///判断警示值重复
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
