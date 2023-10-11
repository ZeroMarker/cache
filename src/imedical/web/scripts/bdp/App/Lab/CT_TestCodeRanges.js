/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于化验项目范围维护
 * @Created on 2013-12-13
 * @Updated on 2013-12-13
 * @LastUpdated on  by sunfengchao
 */
Ext.data.Store.prototype.applySort=function(){ ///解决中文排序的问题
 if (this.sortInfo&& !this.remoteSort){
  var s=this.sortInfo,f=s.field;
  var st=this.fields.get(f).sortType;
  var fn=function(r1,r2){
    var v1=st(r1.data[f]), v2=st(r2.data[f]);
    if(typeof(v1)=="string"){
     return v1.localeCompare(v2);
    }
    return v1>v2?1:(v1<v2? -1:0);
  };
  this.data.sort(s.direction,fn);
  if (this.snapshot && this.snapshot !=this.data){
   this.snapshot.sort(s.direction,fn);
  }
 }
};
Ext.onReady(function(){
 Ext.QuickTips.init();
 Ext.form.Field.prototype.msgTarget = 'side';
 Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
 var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
 var QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTTestCodeRanges&pClassQuery=GetCTSpeciesDataForCmb1";
 var QUERY_ACTION2="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTTestCodeRanges&pClassQuery=GetCTClinicalConditionsDataForCmb1";
 var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTTestCodeRanges&pClassQuery=GetList";
 var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTTestCodeRanges&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTTestCodeRanges";
 var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTTestCodeRanges&pClassMethod=DeleteData";
 var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTTestCodeRanges&pClassMethod=OpenData";
 /*************************删除功能********************************************/
 var btnDel = new Ext.Toolbar.Button({
  text : '删除',
  tooltip : '删除',
  iconCls : 'icon-delete',
  id:'del_btn',
  disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
  handler : function DelData() {
    var records =  grid.selModel.getSelections();
    var recordsLen= records.length;
    if(recordsLen == 0){
      Ext.Msg.show({
       title:'提示',
       minWidth:280,
       msg:'请选择需要删除的行!',
       icon:Ext.Msg.WARNING,
       buttons:Ext.Msg.OK
      }); 
      return
     };
    if(recordsLen > 1){
      Ext.Msg.show({
       title:'提示',
       minWidth:280,
       msg:'删除时每次只能选择一条数据,请重新选择!',
       icon:Ext.Msg.WARNING,
       buttons:Ext.Msg.OK,
       fn:function(btn){
       var view = grid.getView();
       var sm = grid.getSelectionModel();
       if(sm){
         sm.clearSelections();
         var hd = Ext.fly(view.innerHd);
         var c = hd.query('.x-grid3-hd-checker-on');
         if(c && c.length>0){
               Ext.fly(c[0]).removeClass('x-grid3-hd-checker-on')
              }
         }
       }
      });
      }
     else{
     Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
     if (btn == 'yes') {
      Ext.MessageBox.wait('数据删除中,请稍候...', '<font color=blue>提示</font>');
      var gsm = grid.getSelectionModel();// 获取选择列
      var rows = gsm.getSelections();// 根据选择列获取到所有的行
      Ext.Ajax.request({
       url : DELETE_ACTION_URL,
       method : 'POST',
       params : {
        'id':rows[0].get('CTTCRRowId') 
       },
       callback : function(options, success, response) {
        Ext.MessageBox.hide();
        if (success) {
         var jsonData = Ext.util.JSON.decode(response.responseText);
         if (jsonData.success == 'true') {
          Ext.Msg.show({
           title : '<font color=blue>提示</font>',
           msg : '<font color=red>删除成功!</font>',
           icon : Ext.Msg.INFO,
           buttons : Ext.Msg.OK,
           animEl: 'form-save',
           fn : function(btn) {
             var startIndex = grid.getBottomToolbar().cursor;
                        var totalnum=grid.getStore().getTotalCount();
                        if(totalnum==1){   //修改添加后只有一条，返回第一页
                        var startIndex=0
                       }
                       else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
                       {
                         var pagenum=grid.getStore().getCount();
                         if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
                       }
                                                 grid.getStore().load({
                                                 params : {
                                                            start : startIndex,
                                                            limit : pagesize_main
                                                           }
                                                       });
                                                   }
                                               });
         } else {
          var errorMsg = '';
          if (jsonData.info) {
           errorMsg = '<br />错误信息:' + jsonData.info
          }
          Ext.Msg.show({
              title : '<font color=blue>提示</font>',
              msg : '<font color=red>数据删除失败!</font>' + errorMsg,
              minWidth : 200,
              icon : Ext.Msg.ERROR,
              animEl: 'form-save',
              buttons : Ext.Msg.OK
             });
           }
        } else {
         Ext.Msg.show({
             title : '<font color=blue>提示</font>',
             msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
             icon : Ext.Msg.ERROR,
             animEl: 'form-save',
             buttons : Ext.Msg.OK
            });
          }
        }
       }, this);
      }
    }, this);
   } 
  }
 });
   /**********************键盘事件，按键弹出添加窗口******************************************/
  if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  {
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
  } 

 /****************************增加修改的Form**********************************************/
  
 var WinForm = new Ext.form.FormPanel({
  id:'form-save',
  iconCls: 'icon-tabs',
  labelWidth: 100,
  labelAlign : 'right',
  split : true,
  frame : true,
  reader: new Ext.data.JsonReader({root:'list'},
    [ 
      {
         name : 'CTTCRRowId',
         mapping : 'CTTCRRowId',
         type : 'string'
       }, {
         name:'CTTCRParRef',
         mapping:'CTTCRParRef',
         type:'string'
       },{
          name : 'CTTCRSpeciesDR', ///性别
          mapping :'CTTCRSpeciesDR',
          type:'string'
       }, {
	         name : 'CTTCRAge',
	         mapping : 'CTTCRAge',
	         type : 'string'
        },{
	         name:'CTTCRClinicalConditionsDR', /// 临床条件
	         mapping:'CTTCRClinicalConditionsDR',
	         type:'string'
        },{ 
	         name:'CTTCRPatientLocationDR',  /// 病人科室
	         mapping:'CTTCRPatientLocationDR',
	         type:'string'
        }, {
	         name :'CTTCRLowRange',
	         mapping :'CTTCRLowRange',
	         type : 'string'
        },{
	         name:'CTTCRHighRange',
	         mapping:'CTTCRHighRange',
	         type : 'string'
       },{
	         name:'CTTCRPanicLow',
	         mapping:'CTTCRPanicLow',
	         type:'string'
       },{
	          name:"CTTCRPanicHigh",
	          mapping:'CTTCRPanicHigh',
	          type:'string'
        },{
	          name:'CTTCRPregnantLowRange',
	          mapping:'CTTCRPregnantLowRange',
	          type:'string'
        },{
              name:'CTTCRPregnantHighRange',
              mapping:'CTTCRPregnantHighRange',
              type:'string'
        },{
	          name:'CTTCRPregnantPanicLowRange',
	          mapping:'CTTCRPregnantPanicLowRange',
	          type:'string'
        },{
	          name:'CTTCRPregnantPanicHighRange',
	          mapping:'CTTCRPregnantPanicHighRange',
	          type:'string'
        } 
      ]),
     items: [{
     layout: 'column', 
     items:[{
              columnWidth:.4,
              layout:'form',
              height:300,
              xtype:'fieldset',
              title:'基本信息',
              defaultType:'textfield',
              items:[
               {
		           fieldLabel : 'CTTCRRowId',
		           hideLabel : 'True',
		           hidden : true,
		           name : 'CTTCRRowId'   
		         }, {
                   xtype:'combo',
                   fieldLabel : '性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别',
		           name : 'CTTCRSpeciesDR',
		           id:'CTTCRSpeciesDRF',
		           readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCRSpeciesDRF'),
                   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRSpeciesDRF')),
                   store : new Ext.data.Store({
		           autoLoad: true,
		           proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION }),
		           reader : new Ext.data.JsonReader({
                   totalProperty : 'total',
                   root : 'data',
                   successProperty : 'success'
                 }, [ 'CTSPCode', 'CTSPDesc' ])
              }),
	              queryParam : 'desc',
	              triggerAction : 'all',
	              forceSelection : true,
	              selectOnFocus : false,
	              typeAhead : true,
	              minChars : 1,
	              valueField : 'CTSPCode',
	              displayField : 'CTSPDesc',
	              hiddenName : 'CTTCRSpeciesDR' 
	          }, {
                  fieldLabel : '年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;龄',
		          name : 'CTTCRAge',
		          id:'CTTCRAgeF',
                  width:170,
                  readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCRAgeF'),
                  style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRAgeF')) 
       
           }, {
                  xtype:'combo',
	              fieldLabel : '临&nbsp;床&nbsp;条&nbsp;件&nbsp;',
	              name :'CTTCRClinicalConditionsDR',
	              id:'CTTCRClinicalConditionsDRF',
                  readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCRClinicalConditionsDRF'),
                  style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRClinicalConditionsDRF')) ,
                  store : new Ext.data.Store({
	              autoLoad: true,
	              proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION2 }),
	              reader : new Ext.data.JsonReader({
	                 totalProperty : 'total',
	                 root : 'data',
	                 successProperty : 'success'
	                }, [ 'CTCLCCode', 'CTCLCDescription' ])
	             }),
	              queryParam : 'desc',
	              triggerAction : 'all',
	              forceSelection : true,
	              selectOnFocus : false,
	              typeAhead : true,
	              minChars : 1,
	              valueField : 'CTCLCCode',
	              displayField : 'CTCLCDescription',
	              hiddenName : 'CTTCRClinicalConditionsDR' 
	            } , {
                  // xtype:'combo',
                  fieldLabel : '&nbsp;病&nbsp;人&nbsp;科&nbsp;室&nbsp;',
                  name : 'CTTCRPatientLocationDR',
                  id:'CTTCRPatientLocationDRF',
                  readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCRPatientLocationDRF'),
                  style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRPatientLocationDRF'))
               /*   store : new Ext.data.Store({
                  autoLoad: true,
                  proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION2 }),
                  reader : new Ext.data.JsonReader({
                  totalProperty : 'total',
                  root : 'data',
                  successProperty : 'success'
                 }, [ 'CTCLCCode', 'CTCLCDescription' ])
              }),
                queryParam : 'desc',
                triggerAction : 'all',
                forceSelection : true,
                selectOnFocus : false,
                typeAhead : true,
                minChars : 1,
                valueField : 'CTCLCCode',
                displayField : 'CTCLCDescription',
                hiddenName : 'CTTCRClinicalConditionsDR' 
                 } */
             }
           ]  
      },{
               columnWidth:.3,
               xtype:'fieldset',
               title:'普通参考范围',
               height:300,
               layout:'form',
               defaultType:'textfield',
               items:[{
                            fieldLabel:'低值',
                            name:'CTTCRLowRange',
                            id:'CTTCRLowRangeF',
                            readOnly :Ext.BDP.FunLib.Component.DisableFlag('CTTCRLowRangeF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRLowRangeF')) 
                        },{
                            fieldLabel:'高值',
				            name:'CTTCRHighRange',
				            id:'CTTCRHighRangeF',
                            readOnly :Ext.BDP.FunLib.Component.DisableFlag('CTTCRHighRangeF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRHighRangeF')) 
                       },{
				            fieldLabel:'警告低值',
				            name:'CTTCRPanicLow',
				            id:'CTTCRPanicLowF',
				            readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCRPanicLowF'),
				            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRPanicLowF')) 
				         },{
                            fieldLabel:'警告高值',
			                name:'CTTCRPanicHigh',
			                id:'CTTCRPanicHighF',
			                readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCRPanicHighF'),
			                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRPanicHighF')) 
			           }]
			      },{
		                    columnWidth:.3,
		                    layout:'form',
		                    defaultType:'textfield',
		                    xtype:'fieldset',
		                    title:'怀孕参考范围',
		                    height:300,
		                    items:[
		                    {
		                         fieldLabel:'低值',
		                         name:'CTTCRPregnantLowRange',
		                         id:'CTTCRPregnantLowRange',
		                         readOnly :Ext.BDP.FunLib.Component.DisableFlag('CTTCRPregnantLowRange'),
		                         style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRPregnantLowRange'))
		                    }, {
		                         fieldLabel:'高值' ,
		                         name:'CTTCRPregnantHighRange',
		                         id:'CTTCRPregnantHighRange',
		                         readOnly :Ext.BDP.FunLib.Component.DisableFlag('CTTCRPregnantHighRange'),
		                         style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRPregnantHighRange'))
		                    }, {
		                        fieldLabel:'警告低值',
		                        name:'CTTCRPregnantPanicLowRange',
		                        id:'CTTCRPregnantPanicLowRange',
		                        readOnly :Ext.BDP.FunLib.Component.DisableFlag('CTTCRPregnantPanicLowRange'),
		                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRPregnantPanicLowRange'))
		                    }, {
		                        fieldLabel:'警告高值',
		                        name:'CTTCRPregnantPanicHighRange',
		                        id:'CTTCRPregnantPanicHighRange',
		                        readOnly :Ext.BDP.FunLib.Component.DisableFlag('CTTCRPregnantPanicHighRange'),
		                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCRPregnantPanicHighRange'))
		                    }
		                ]
      
      }]
  }]
  });
 /******************************增加修改时弹出窗口***********************************/
 var win = new Ext.Window({
  title : '',
  width : 900,
  height : 280,
  layout : 'fit',
  plain : true,// true则主体背景透明
  modal : true,
  frame : true,
  autoScroll : false,
  collapsible : true,
  hideCollapseTool : true,
  titleCollapse : true,
  bodyStyle : 'padding:3px',
  buttonAlign : 'center',
  closeAction : 'hide',
  labelWidth : 100,
  items : WinForm,
  buttons : [{
   text : '保存',
   id:'save_btn',
   disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'), 
   handler : function AddData() {
      if (win.title == "添加") {
      WinForm.form.submit({
      clientValidation : true, // 进行客户端验证
      waitMsg : '正在提交数据请稍后',
      waitTitle : '<font color=blue>提示</font>',
      url : SAVE_ACTION_URL_New,
      method : 'POST',
      success : function(form, action) {
       if (action.result.success == 'true') {
        win.hide();
        var myrowid = action.result.id;
        Ext.Msg.show({
             title : '<font color=blue>提示</font>',
             msg : '<font color=green>添加成功!</font>',
             animEl: 'form-save',
             icon : Ext.Msg.INFO,
             buttons : Ext.Msg.OK,
             fn : function(btn) {
              var startIndex = grid.getBottomToolbar().cursor;
              grid.getStore().load({
                 params : {
                    start : 0,
                    limit : pagesize_main,
                    rowid : myrowid
                   }
                  });
               }
           });
       } else {
        var errorMsg = '';
        if (action.result.errorinfo) {
         errorMsg = '<br/>错误信息:' + action.result.errorinfo
        }
        Ext.Msg.show({
            title : '<font color=blue>提示</font>',
            msg : '<font color=red>添加失败!</font>' ,
            minWidth : 200,
            animEl: 'form-save',
            icon : Ext.Msg.ERROR,
            buttons : Ext.Msg.OK
           });
          }
        },
      failure : function(form, action) {
       Ext.Msg.show({
           title : '<font color=blue>提示</font>',
           msg : '<font color=red>添加失败!</font>' ,
           minWidth : 200,
           animEl: 'form-save',
           icon : Ext.Msg.ERROR,
           buttons : Ext.Msg.OK
          });
      }
     })
    } else {
     Ext.MessageBox.confirm('<font color=blue>提示</font>', '<font color=red>确定要修改该条数据吗?</font>', function(btn) {
      if (btn == 'yes') {
       WinForm.form.submit({
        clientValidation : true, // 进行客户端验证
        waitMsg : '正在提交数据请稍后...',
        waitTitle : '<font color=blue>提示</font>',
        url : SAVE_ACTION_URL_New,
        method : 'POST',
        success : function(form, action) {
         if (action.result.success == 'true') {
          win.hide();
          var myrowid = action.result.id;
          Ext.Msg.show({
           title : '<font color=blue>提示</font>',
           msg : '<font color=green>修改成功!</font>',
           animEl: 'form-save',
           icon : Ext.Msg.INFO,
           buttons : Ext.Msg.OK,
           fn : function(btn) {
            var startIndex = grid.getBottomToolbar().cursor;
            grid.getStore().load({
               params : {
                  start : 0,
                  limit : pagesize_main,
                  rowid : myrowid
                 }
              });
            }
          });
         } else {
          var errorMsg = '';
          if (action.result.errorinfo) {
           errorMsg = '<br/>错误信息:' + action.result.errorinfo
          }
          Ext.Msg.show({
              title : '<font color=blue>提示</font>',
              msg : '<font color=red>修改失败!</font>' ,
              minWidth : 200,
              animEl: 'form-save',
              icon : Ext.Msg.ERROR,
              buttons : Ext.Msg.OK
             });
          }
        },
        failure : function(form, action) {
          Ext.Msg.show({
              title : '<font color=blue>提示</font>',
              msg : '<font color=red>修改失败!</font>' ,
              minWidth : 200,
              animEl: 'form-save',
              icon : Ext.Msg.ERROR,
              buttons : Ext.Msg.OK
             });
          }
         })
        }
      }, this);
     }
    }
  }, {
   text : '取消',
   handler : function() {
   win.hide();
   }
  }],
  listeners : {
   "show" : function() {
   Ext.getCmp("form-save").getForm().findField("CTTCRSpeciesDR").focus(true,300);
   },
   "hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
   "close" : function() {
   }
  }
 });
 /************************************增加按钮****************************************/
 var btnAddwin = new Ext.Toolbar.Button({
    text : '添加',
    tooltip : '添加',
    iconCls : 'icon-add',
    id:'add_btn',
    disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
    handler : function AddData() {
    win.setTitle('添加');
    win.setIconClass('icon-add');
    win.show('new1');
    WinForm.getForm().reset();
    },
    scope : this
   });
 /**************************************修改按钮*************************************/
 var btnEditwin = new Ext.Toolbar.Button({
    text : '修改',
    tooltip : '修改',
    iconCls : 'icon-update',
    id:'update_btn',
    disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
    handler : function UpdateData() {
     var records =  grid.selModel.getSelections();
    var recordsLen= records.length;
    if(recordsLen == 0){
      Ext.Msg.show({
       title:'提示',
       minWidth:280,
       msg:'请选择需要修改的行!',
       icon:Ext.Msg.WARNING,
       buttons:Ext.Msg.OK
      }); 
      return
     };
    if(recordsLen > 1){
      Ext.Msg.show({
       title:'提示',
       minWidth:280,
       msg:'修改时每次只能选择一条数据,请重新选择!',
       icon:Ext.Msg.WARNING,
       buttons:Ext.Msg.OK,
       fn:function(btn){
       var view = grid.getView();
       var sm = grid.getSelectionModel();
       if(sm){
         sm.clearSelections();
         var hd = Ext.fly(view.innerHd);
         var c = hd.query('.x-grid3-hd-checker-on');
         if(c && c.length>0){
               Ext.fly(c[0]).removeClass('x-grid3-hd-checker-on')
              }
         }
       }
      });
      }
     else{
           win.setTitle('修改');
	       win.setIconClass('icon-update');
	       win.show('');
	       loadFormData(grid);
	      }
        }
    });
 /*******************************数据保存格式为json格式**************************************/
 var ds = new Ext.data.Store({
    proxy : new Ext.data.HttpProxy({
       url : ACTION_URL
      }),// 调用的动作
    reader : new Ext.data.JsonReader({
       totalProperty : 'total',
       root : 'data',
       successProperty : 'success'
      }, [ 
       {
         name : 'CTTCRRowId',
         mapping : 'CTTCRRowId',
         type : 'string'
        },{
         name:'CTTCRParRef',
         mapping:'CTTCRParRef',
         type:'string'
        }, {
         name : 'CTTCRSpeciesDR',
         mapping :'CTTCRSpeciesDR',
         type:'string'
        } ,{
         name : 'CTTCRAge',
         mapping : 'CTTCRAge',
         type : 'string'
        },{
         name:'CTTCRClinicalConditionsDR',
         mapping:'CTTCRClinicalConditionsDR',
         type:'string'
        },{
         name:'CTTCRPatientLocationDR',
         mapping:'CTTCRPatientLocationDR',
         type:'string'
        } , {
         name :'CTTCRLowRange',
         mapping :'CTTCRLowRange',
         type : 'string'
        },{
         name:'CTTCRHighRange',
         mapping:'CTTCRHighRange',
         type : 'string'
        },{
           name:'CTTCRPanicLow',
           mapping:'CTTCRPanicLow',
           type:'string'
          },{
          name:"CTTCRPanicHigh",
          mapping:'CTTCRPanicHigh',
          type:'string'
        },{
          name:'CTTCRPregnantLowRange',
          mapping:'CTTCRPregnantLowRange',
          type:'string'
        
        },{
          name:'CTTCRPregnantHighRange',
          mapping:'CTTCRPregnantHighRange',
          type:'string'
        },{
          name:'CTTCRPregnantPanicLowRange',
          mapping:'CTTCRPregnantPanicLowRange',
          type:'string'
        },{
           name:'CTTCRPregnantPanicHighRange',
          mapping:'CTTCRPregnantPanicHighRange',
          type:'string'
         } 
       ]) 
   });
 /***************************加载数据****************************************************/ 
 ds.load({
    params : {
     start : 0,
     limit : pagesize_main
    },
    callback : function(records, options, success) {
    }
   }); // 加载数据
 var paging = new Ext.PagingToolbar({
    pageSize : pagesize_main,
    store : ds,
    displayInfo : true,
    displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
    emptyMsg : "没有记录"
   })
  
 /***************************** 增删改工具条*****************************************/
 var tbbutton = new Ext.Toolbar({
  enableOverflow : true,
  items : [btnAddwin, '-', btnEditwin, '-', btnDel ]
  })
 /*********************** 搜索工具条***********************************************/
 var btnSearch = new Ext.Button({
    id : 'btnSearch',
    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
    iconCls : 'icon-search',
    text : '搜索',
    handler : function() {
    grid.getStore().baseParams={   
      sex : Ext.getCmp("sex").getValue()
    };
    grid.getStore().load({
      params : {
         start : 0,
         limit : pagesize_main
         }
       });
      }
     });
 /******************************刷新工作条****************************************/
 var btnRefresh = new Ext.Button({
    id : 'btnRefresh',
    iconCls : 'icon-refresh',
    text : '重置',
    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
    handler : function refresh() {
     Ext.getCmp("sex").reset();
     grid.getStore().baseParams={};
     grid.getStore().load({
     params : {
        start : 0,
        limit : pagesize_main
       }
      });
     }
   });
 /*************************将工具条放到一起****************************************/
// 将工具条放到一起
 var tb = new Ext.Toolbar({
    id : 'tb',
    items : ['性别：', { 
           xtype : 'combo', 
           id : 'sex' ,
           disabled : Ext.BDP.FunLib.Component.DisableFlag('sex'),
            store : new Ext.data.Store({
             autoLoad: true,
             proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION }),
             reader : new Ext.data.JsonReader({
                   totalProperty : 'total',
                   root : 'data',
                   successProperty : 'success'
                 }, [ 'CTSPCode', 'CTSPDesc' ])
              }),
               queryParam : 'desc',
               triggerAction : 'all',
               forceSelection : true,
               selectOnFocus : false,
               typeAhead : true,
               minChars : 1,
               valueField : 'CTSPCode',
               displayField : 'CTSPDesc',
               hiddenName : 'CTTCRSpeciesDR' 
         }, btnSearch, '-', btnRefresh, '->'
    ],
    listeners : {
     render : function() {
      tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
     }
    }
   });
   
 /***************************** create the Grid *************************************/
 var sm= new Ext.grid.RowSelectionModel({singleSelect:true})
 var cm=new Ext.grid.ColumnModel([new Ext.grid.CheckboxSelectionModel(), 
                      {
       header : 'CTTCRRowId',
       width : 160,
       sortable : true,
       dataIndex : 'CTTCRRowId',
       hidden : true
      },{
       header:'CTTCRParRef',
       width:40,
       hidden:true,
       dataIndex:'CTTCRParRef'
      }, {
       header : '性别',
       width : 90,
       sortable : true,
       renderer: Ext.BDP.FunLib.Component.GirdTipShow,
       dataIndex : 'CTTCRSpeciesDR'
      }, {
       header : '年龄',
       width : 90,
       sortable : true,
       renderer: Ext.BDP.FunLib.Component.GirdTipShow,
       dataIndex : 'CTTCRAge'
      }, {
       header : '临床条件',
       width : 90,
       sortable : true,
       dataIndex : 'CTTCRClinicalConditionsDR' 
      },{
       header : '病人科室',
       width : 90,
       sortable : true,
       dataIndex : 'CTTCRPatientLocationDR' 
      },{
          header : '低值',
          width : 85,
          sortable : true,
          dataIndex : 'CTTCRLowRange'
      },{
           header : '高值',
           width : 85,
           sortable : true,
           dataIndex : 'CTTCRHighRange'
        },{
            header : '警告低值',
            width : 85,
            sortable : true,
            dataIndex : 'CTTCRPanicLow'
         },{
             header : '警告高值',
             width : 85,
             sortable : true,
             dataIndex : 'CTTCRPanicHigh'
        }, {
			 header : '怀孕低值',
			 width : 85,
			 sortable : true,
			 dataIndex : 'CTTCRPregnantLowRange'
         },{
			 header : '怀孕高值',
		     width : 85,
			 sortable : true,
             dataIndex : 'CTTCRPregnantHighRange'
          },{
                          
              header : '怀孕警告低值',
              width : 85,
              sortable : true,
              dataIndex : 'CTTCRPregnantPanicLowRange'
           },{
              header : '怀孕警告高值',
			  width : 85,
			  sortable : true,
			  dataIndex : 'CTTCRPregnantPanicHighRange'
          }]);
      
 var grid = new Ext.grid.GridPanel({
    id : 'grid',
    region : 'center',
    width : 900,
    height : 500,
    closable : true,
    store : ds,
    trackMouseOver : true,
    singleSelect: true ,
    tools:Ext.BDP.FunLib.Component.HelpMsg,
    sm:sm ,
    cm:cm,
    stripeRows : true,
    autoScroll:true,
    columnLines : true, //在列分隔处显示分隔符
    loadMask : {
    msg : '数据加载中,请稍候...'
    },
    title : '普通/门诊病人',
    stateful : true,
    viewConfig : {
    forceFit : true,
    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
       enableRowBody: true // 
    },
    bbar : paging,
    tbar : tb,
    stateId : 'grid'
   });
  
     /*
  function getRaPanel(){
   var RangePanel = new Ext.Window({
   title:'检验项目范围',
   width:1000,
   height:600,
   layout:'fit',
   plain:true,//true则主体背景透明
   modal:true,
   frame:true,
   autoScroll: true,
   collapsible:true,
   hideCollapseTool:true,
   titleCollapse: true,
   bodyStyle:'padding:3px',
   buttonAlign:'center',
   closeAction:'hide',
   labelWidth:55,
   items: grid,
   listeners:{
     "show":function(){
     },
     "hide":function(){
     },
     "close":function(){
     }
     }
  });
  return RangePanel; 
 }     
 */
/***************************************双击事件*************************************/
    var loadFormData = function(grid){
         var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
         if (!_record) {
             Ext.Msg.alert('修改操作', '请选择要修改的一项!');
         } else {
           WinForm.form.load( {
                 url : OPEN_ACTION_URL + '&id='+ _record.get('CTTCRRowId'),  
                 success : function(form,action) {
          },
                 failure : function(form,action) {
                 Ext.Msg.alert('编辑', '载入失败!');
                 }
             });
         }
     };
     grid.on("rowdblclick", function(grid, rowIndex, e) {
       var row = grid.getStore().getAt(rowIndex).data;
    win.setTitle('修改');      ///双击后
    win.setIconClass('icon-update');
    win.show('');
    loadFormData(grid)
     }); 
 var viewport = new Ext.Viewport({
    layout : 'border',
    items : [grid]
   });
});