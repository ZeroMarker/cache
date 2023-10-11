/**按钮权限说明
*提交、删除、附件：只有新建状态的单子可用
*撤销：
*	1.单据不是新建状态、
*	2.分状态
*		①单据刚提交、还未开始审核
*			本人和对应审核权限人可操作
*		②单据状态提交、还未审核结束
*			顺序号≧当前顺序号的人权限人可撤销
*	
**/
var userid = session['LOGON.USERID'];
var hisdeptdr = session['LOGON.CTLOCID'];
// 年度///////////////////////////////////
var projUrl = 'herp.budg.costclaimapplyexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl + '?action=year&flag=1',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '申请年月',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 12,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
/////////////////申请单号//////////////////////////
var billcodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['billcode', 'billcode'])
		});

billcodeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=getbillcode'+'&userdr='+userid,
						method : 'POST'
					});
		});

var billcodeField = new Ext.form.ComboBox({
			fieldLabel : '申请单号',
			store : billcodeDs,
			displayField : 'billcode',
			valueField : 'billcode',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择单号...',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

//////查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var year = yearCombo.getValue();
	    var billcode=billcodeField.getValue();
		itemGrid.load({params:{start:0,limit:25,year:year,userid:userid,hisdeptdr:hisdeptdr,billcode:billcode}});
	}
});

//////添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){

	addFun(itemGrid);			//调用申请单据管理界面
	}
	
});

var upload =
   function(){
    
        var rowObj = itemGrid.getSelectionModel().getSelections(); 
        var len = rowObj.length;
        var message="请选择对应的单据！";  
        if(len < 1){
            Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            return false;
        }
        var billstates  = rowObj[0].data['billstate'];
        if(billstates!=="新建")
        {
        Ext.Msg.show({title:'注意',msg:"单据已提交或审核，不能上传！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});		
        return;
        }else{
            var rowid = rowObj[0].get('rowid');
            var dialog = new Ext.ux.UploadDialog.Dialog({
            url: 'herp.budg.costclaimapplyexe.csp?action=Upload&rowid='+rowid,
            reset_on_hide: false, 
            permitted_extensions:['gif','jpeg','jpg','png','bmp'],
            allow_close_on_upload: true,
            upload_autostart: false,
            title:'上传报销单信息图片'
            //post_var_name: 'file'
      });
      dialog.show();
        }
    };



del = function(){
var selectedRow = itemGrid.getSelectionModel().getSelections();
         var selectedRow = itemGrid.getSelectionModel().getSelections();		
         var rowids	 = selectedRow[0].data['rowid'];
         var billstates  = selectedRow[0].data['billstate'];
         if(billstates!=="新建")
         {
         Ext.Msg.show({title:'注意',msg:"申请单已提交或审核，不允许删除！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});		
        	return;
         }
         else
         {
	         delFun(rowids);
	     }
};
  
back=function(){
var selectedRow = itemGrid.getSelectionModel().getSelections();
	var selectedRow = itemGrid.getSelectionModel().getSelections();		
        var rowid	=selectedRow[0].data['rowid'];
        var billstates  = selectedRow[0].data['billstate'];
        var billstate 	=selectedRow[0].data['billstate'];
        var ChkSatte   =selectedRow[0].data['ChkSatte'];
        var CurStepNO 	=selectedRow[0].data['CurStepNO'];  
        var StepNO 	=selectedRow[0].data['StepNO']; 
        
        if(billstates=="新建"){
	       	Ext.Msg.show({title:'注意',msg:"申请单未提交,不能撤销！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});		
        	return;
	    }
        else if((billstates=="提交")&&(ChkSatte==""))
        {
	       backoutfun(rowid,window.userid);
	    }
        else if((StepNO>=CurStepNO)&&((StepNO!=="")&&(CurStepNO!=="")))
        {
	        backoutfun(rowid,window.userid);
        }
        else if(StepNO=="")
        {
	        Ext.Msg.show({title:'注意',msg:'已审核，不可撤销！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	        return;
        }else
        {
	        Ext.Msg.show({title:'注意',msg:'不是当前权限人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	        return;
        }
};


submits=function(){
         var selectedRow = itemGrid.getSelectionModel().getSelections();  		
         rowid	=selectedRow[0].data['rowid']; 
         var billcodes	=selectedRow[0].data['billcode'];
         var billstate 	=selectedRow[0].data['billstate'];
         var ChkSatte   =selectedRow[0].data['ChkSatte'];
         var CurStepNO 	=selectedRow[0].data['CurStepNO'];  
         var StepNO 	=selectedRow[0].data['StepNO']; 
         
         if(billstate=="提交"||(billstate=="完成"))
         {
	         Ext.Msg.show({title:'注意',msg:'单据已结束或已提交，不允许提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	         return;
         }
         else{
	 		submitfun(rowid,this.userid,billcodes);
	 		itemGrid.load({params:{start:0, limit:25,userid:userid}});
           }
};

accessory=function(){
var selectedRow = itemGrid.getSelectionModel().getSelections();
         var selectedRow = itemGrid.getSelectionModel().getSelections();		
         var billstates  = selectedRow[0].data['billstate'];
         rowid	=selectedRow[0].data['rowid'];
          var ChkFstDR =selectedRow[0].data['ChkFstDR']; 
         if(billstates!=="新建"){
	         Ext.Msg.show({title:'注意',msg:"单据已提交或审核，不能上传！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});		
        	return;
         }
	 accessoryFun(rowid);
};


var itemGrid = new dhc.herp.Grid({
		    title: '一般支出报销申请',
		    region : 'north',
		    url: 'herp.budg.costclaimapplyexe.csp',
			fields : [{
						header : '申请表ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'select',
						header : '选择',
						editable:false,
						width : 130,
                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{
						var bs = record.data['billstate'];
						var cs = record.data['ChkSatte'];
						var curno = record.data['CurStepNO'];
						var no = record.data['StepNO'];
										
						if(bs=="新建"){
							return '<span style="color:blue;cursor:hand"><BLINK id="submit" onclick=submits();> 提交 </BLINK></span>'+'<b> </b>'
							+'<span style="color:gray;cursor:hand"><BLINK id="revocation" onclick=back();> 撤销 </BLINK></span>'+'<b> </b>'
							+'<span style="color:blue;cursor:hand"><BLINK id="delete"  onclick=del();> 删除 </BLINK></span>'+'<b> </b>' 
							+'<span style="color:blue;cursor:hand"><BLINK id="accessory" onclick=upload();> 附件 </BLINK></span>'+'<b> </b>'
						}else if((bs=="提交")&&(cs=="")){
							return '<span style="color:gray;cursor:hand"><BLINK id="submit" onclick=submits();> 提交 </BLINK></span>'+'<b> </b>'
							+'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=back();> 撤销 </BLINK></span>'+'<b> </b>'
							+'<span style="color:gray;cursor:hand"><BLINK id="delete" onclick=del();> 删除 </BLINK></span>'+'<b> </b>' 
							+'<span style="color:gray;cursor:hand"><BLINK id="accessory" onclick=upload();> 附件 </BLINK></span>'+'<b> </b>'
						}else {
							//alert(no+"----"+curno); //当前审批号与登录人审批号不能同时为空，这种一般是审核完成的情况
							if((no>=curno)&&((no!=="")&&(curno!==""))){
								return '<span style="color:gray;cursor:hand"><BLINK id="submit" onclick=submits();> 提交 </BLINK></span>'+'<b> </b>'
								+'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=back();> 撤销 </BLINK></span>'+'<b> </b>'
								+'<span style="color:gray;cursor:hand"><BLINK id="delete" onclick=del();> 删除 </BLINK></span>'+'<b> </b>' 
								+'<span style="color:gray;cursor:hand"><BLINK id="accessory" onclick=upload();> 附件 </BLINK></span>'+'<b> </b>'
							}else {
								return '<span style="color:gray;cursor:hand"><BLINK id="submit" onclick=submits();> 提交 </BLINK></span>'+'<b> </b>'
								+'<span style="color:gray;cursor:hand"><BLINK id="revocation" onclick=back();> 撤销 </BLINK></span>'+'<b> </b>'
								+'<span style="color:gray;cursor:hand"><BLINK id="delete" onclick=del();> 删除 </BLINK></span>'+'<b> </b>' 
								+'<span style="color:gray;cursor:hand"><BLINK id="accessory" onclick=upload();> 附件 </BLINK></span>'+'<b> </b>'
							}
						};
						},
						dataIndex : 'select',
                        hidden : false

					},{
						id : 'File',
						header : '附件图片',
						editable:false,
						width : 100,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'File'
					}, {
						id : 'CompName',
						header : '医疗单位',
						width : 80,
                        align:'left',
						editable:false,
						hidden : true,
						dataIndex : 'CompName'

					},{
						id : 'checkyearmonth',
						header : '核算年月',
						width : 80,
                        align:'left',
						editable:false,
						dataIndex : 'checkyearmonth'

					},{
						id : 'billcode',
						header : '报销单号',
						editable:false,
						width : 150,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'billcode'

					}, {
						id : 'dname',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'dname',
						hidden : false
					}, {
						id : 'applyer',
						header : '申请人',
						editable:false,
						width : 120,
						dataIndex : 'applyer'

					},{
						id : 'reqpay',
						header : '报销金额',
						width : 100,
						editable:false,
                        align:'right',
						dataIndex : 'reqpay'

					}, {
						id : 'actpay',
						header : '审批金额',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'actpay'
						
					},{
						id : 'applydate',
						header : '申请时间',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'applydate'

					},{
						id : 'billstate',
						header : '单据状态',
						width : 100,
						///align : 'right',
						editable:false,
                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'billstate'

					},{
						id : 'applydecl',
						header : '资金申请说明',
						width : 120,
						////align : 'right',
						editable:false,
						dataIndex : 'applydecl'

					},{
						id : 'budgetsurplus',
						header : '审批后结余',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'budgetsurplus'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "预算内") {
							return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:red;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
                        id : 'applydr',
						header : '资金申请单号id',
						width : 100,
						editable:false,
						align:'right',
                        hidden:true,
						dataIndex : 'applydr'

                     }
					,{
                        id : 'applycode',
						header : '资金申请单号',
						width : 100,
						editable:false,
						align:'right',
                        hidden:true,
						dataIndex : 'applycode'

                     },{
						id : 'isover',
						header : '审核结束否',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'isover'

					}, {
						id : 'deprdr',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'deprdr',
						hidden:true
					}, {
						id : 'sOver',
						header : '审批是否完成',
						editable:false,
						width : 120,
						dataIndex : 'sOver',
						hidden:true
					}, {
						id : 'audname',
						header : '归口科室',
						editable:false,
						width : 120,
						dataIndex : 'audname',
						hidden:false
					}, {
						id : 'audeprdr',
						header : '归口科室dr',
						editable:false,
						width : 120,
						dataIndex : 'audeprdr',
						hidden:true
					}, {
						id : 'CheckDR',
						header : '审批流',
						editable:false,
						width : 120,
						dataIndex : 'CheckDR',
						hidden:true
					}, {
						id : 'FundSour',
						header : '资金来源',
						editable:false,
						width : 120,
						dataIndex : 'FundSour',
						hidden:true
					}, {
						id : 'FundSourN',
						header : '资金来源',
						editable:false,
						width : 120,
						dataIndex : 'FundSourN'
					}, {
						id : 'ChkSatte',
						header : '审核状态',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'ChkSatte'
					}, {
						id : 'CurStepNO',
						header : '当前审批号',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'CurStepNO'
					}, {
						id : 'StepNO',
						header : '登录人顺序号',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'StepNO'
					}],
                    tbar:['申请年月:',yearCombo,'-','申请单号:',billcodeField,'-',findButton,'-',addButton]

				////		tbar:['申请年月:',yearCombo,'-',findButton,'-',addButton,'-',delButton,'-', backout,'-','-',submit]
                                               
						
		});

   itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	
	params:{start:0, limit:25,userid:userid,hisdeptdr:hisdeptdr},

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}
});



// 单击单据状态 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	if (columnIndex == 12) {
                	
		var records = itemGrid.getSelectionModel().getSelections();
	
		var rowids  = records[0].get("rowid");
	
                billstate(rowids);


	}
//单击报销单号单元格
       else if (columnIndex == 6) {
                /*	
		var records   = itemGrid.getSelectionModel().getSelections();
		var applydecls= records[0].get("applydecl");
		var applyers  = records[0].get("applyer");
	        var deprdrs   = records[0].get("deprdr");
		var billcodes = records[0].get("billcode");
                var rowids    = records[0].get("rowid");
                var applycod  = records[0].get("applycode");
                */
              ///  paydetail(rowids,applydecls,applyers,deprdrs,billcodes);
             EditFun(itemGrid);


	}
       
       else if (columnIndex == 16) {
                	
		var records   = itemGrid.getSelectionModel().getSelections();
		var accessor= records[0].get("accessory");
		var rowids    = records[0].get("rowid");

                if(accessory="上传")
               accessoryFun(rowids);
                ////  MSComDlg_CommonDialog(0|1|2|3|4);

                else
                lookup(rowids);


	}
	
	//上传图片
	//alert(columnIndex);
	if (columnIndex == 3) {
		var records = itemGrid.getSelectionModel().getSelections();
		var rowid   = records[0].get("rowid");
		payuploadFun(rowid);
	}

});


