//调整
var AdjustButton = new Ext.Toolbar.Button({
   	        text : '数据保存',
			iconCls : 'option',
			handler : function() {
			afterEdit(jxunitGrid);
		}
  });	 
var jxunitGrid = new dhc.herp.jxunitGrid({
            title:'考核指标数据调整',
		    region: 'center',
			height:450,
		    url: 'dhc.pa.basicuintpacaluexe.csp',
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
					    var rowObj = itemGrid.getSelectionModel().getSelections();
						var curstate = rowObj[0].get("auditstate");
						
		                var record = grid.getStore().getAt(rowIndex);
						if (((curstate=="未提交")||(curstate==0))&&((columnIndex==12)||(columnIndex==11)||(columnIndex==1))){
							var cl1 = grid.getColumnModel().getIndexById("Rscore");							  
							var cl2 = grid.getColumnModel().getIndexById("estdesc");
							//alert(cl2);
							grid.getColumnModel().setEditable(cl1,true);
							grid.getColumnModel().setEditable(cl2,true);
							return true;
						 } else {
							 Ext.Msg.show({title:'错误',msg:'此列不能进行修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							 return false;
						 }
						
						
						/*if (record.data.iscolType== 1)  //非计算类指标--暂时都可以编辑
						{
						//	alert(columnIndex);
							if (((curstate=="未提交")||(curstate==0))&&((columnIndex==12)||(columnIndex==11))) {
								  var cl1 = grid.getColumnModel().getIndexById("Rscore");							  
								  var cl2 = grid.getColumnModel().getIndexById("estdesc");
								  //alert(cl2);
								  grid.getColumnModel().setEditable(cl1,true);
								  grid.getColumnModel().setEditable(cl2,true);
								  return true;
							 } else {
							 Ext.Msg.show({title:'错误',msg:'此列不能进行修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							 return false;
							 }
						 }else{  //计算类指标  --描述可以编辑
						    if((curstate=="未提交")||(curstate==0)){
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
									Ext.Msg.show({title:'错误',msg:'此列不能进行修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								 }
						   }
					   }*/
					}
            },
			fields : [
			       new Ext.grid.CheckboxSelectionModel({hidden : false,editable:false}),
			       {
						header : '考核记录主表ID',
						dataIndex : 'mainrowid',
						editable:false,
						hidden : true
					},{
						header : '考核记录明细表ID',
						dataIndex : 'detailrowid',
						editable:false,
						hidden : true
					},  {
						id : 'urperiod',
						header : '核算期',
						editable:false,
						width : 80,
						dataIndex : 'urperiod'

					},{
						id : 'urdeptname',
						header : '科室名称',
						editable:false,
						width : 100,
						dataIndex : 'urdeptname'

					},{
						id : 'iscolType',
						header : '是否计算行指标',
						width : 150,
						editable:false,
						hidden:true,
						dataIndex : 'iscolType'

					},{
						id : 'kpiname',
						header : '指标名称',
						width : 150,
						editable:false,
						dataIndex : 'kpiname'

					},{
						id : 'targetvalue',
						header : '目标值',
						editable:false,
						align:'right',
						width : 80,
						dataIndex : 'targetvalue'

					}, {
						id : 'actvalue',
						header : '实际值',
						editable:false,
						align:'right',
						width : 80,
						dataIndex : 'actvalue'
					},{
						id : 'score',
						header : '考核分',
						editable:false,
						width : 80,
						align:'right',
						dataIndex : 'score'
					},{
						id : 'Rscore',
						header : '最终考核分',
						editable:false,
						width : 80,
						align:'right',
						dataIndex : 'Rscore'
					},
					{
						id : 'estdesc',
						header : '问题描述',
						editable:false,
						width : 80,
						dataIndex : 'estdesc'

					},{
						id : 'detailinfo',
						header : '明细',
						editable:false,
						width : 80,
						hidden:true,
						dataIndex : 'detailinfo'
					}, {
						id : 'ratedvalue',
						header : '加权后得分',
						editable:false,
						align:'right',
						width : 80,
						dataIndex : 'ratedvalue'
					},{
						id : 'methodname',
						header : '考核方法',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'methodname'
					}],
                    tbar:[]					
		});
/**
    jxunitGrid.btnAddHide();  //隐藏增加按钮
   	jxunitGrid.btnSaveHide();  //隐藏保存按钮
    jxunitGrid.btnDeleteHide(); //隐藏删除按钮
    jxunitGrid.btnResetHide();  //隐藏重置按钮
    jxunitGrid.btnPrintHide();  //隐藏打印按钮
	
    jxunitGrid.hiddenButton(1);
    jxunitGrid.hiddenButton(2);
	jxunitGrid.hiddenButton(3);
**/
function kpiconfirm(period,deptname,kpiname,periodType)
{
   Ext.MessageBox.confirm('提示','确定要修改该期间指标？', function(btn){
    if (btn == 'yes'){
	    
        window.open("dhc.pa.basicuintpacaludetail.csp?start=0&limit=20&period="+period+"&deptdr="+deptname+"&kpidrs="+kpiname+"&periodType="+periodType+"&userID="+userdr, "", "toolbar=no,height=500,width=800");
        //window.open("dhc.pa.basicuintpacaludetail.csp?start=0&limit=20&period=201501&periodType=Q&userID="+userdr, "", "toolbar=no,height=500,width=800");

    }
});
   
}


function afterEdit(obj){    //每次更改后，触发一次该事件 
		var rowObj = jxunitGrid.getSelectionModel().getSelections();
		
			var schemObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要调整数据的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			  var curstate=schemObj[i].get("auditstate");
			  if (curstate!="未提交")
			  {
				Ext.Msg.show({title:'错误',msg:curstate+'不能进行修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			  }
			else{ //encodeURIComponent(rowObj[i].get("estdesc"))
			      // alert(encodeURIComponent(rowObj[i].get("estdesc")));
				  var para='dhc.pa.basicuintpacaluexe.csp?action=updateNew&mainrowid='+rowObj[i].get("mainrowid")+'&detailrowid='+rowObj[i].get("detailrowid")+'&period='+rowObj[i].get("urperiod")+'&periodType='+periodTypeField.getValue()+'&userID='+userdr+'&Rscore='+rowObj[i].get("Rscore")+"&desc="+encodeURIComponent(rowObj[i].get("estdesc"));
				  
				   Ext.Ajax.request({
					url:para,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						console.log(result);
						var jsonData = Ext.util.JSON.decode(result.responseText);
						//alert(result.responseText);
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'注意',msg:'数据保存成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								jxunitGrid.load({params:{start:0, limit:25}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:'数据保存失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
