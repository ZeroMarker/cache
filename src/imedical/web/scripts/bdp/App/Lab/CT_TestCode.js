/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 检验项目维护。
 * @Created on 2013-12-6
 * @Updated on  
 * @LastUpdated on   by sunfengchao
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
Ext.onReady(function() {
 Ext.QuickTips.init();
 Ext.form.Field.prototype.msgTarget = 'side';
 Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
 var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
 var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTTestCode&pClassQuery=GetList";
 var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTTestCode&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTTestCode";
 var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTTestCode&pClassMethod=DeleteData";
 var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTTestCode&pClassMethod=OpenData";
 /**********************************删除功能***************************************/
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
        'code':rows[0].get('CTTCCode') 
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
 /************************键盘事件，按A键弹出添加窗口。***********************/
   if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  {
     Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
  } 
 /********************************增加修改的Form************************************/
 var WinForm = new Ext.form.FormPanel({
    id : 'form-save',
    labelAlign : 'left',
    width :200,
    split : true,
    frame : true,
    waitMsgTarget : true,
    defaults : {
     anchor: '85%',
     bosrder : false  // ,CTTCResultLength,CTTCTestMethodDR,CTTCShowInCummulative)
    },
    reader:new Ext.data.JsonReader({root:'list'},
   [ 
      {
         name : 'CTTCCode',
         mapping : 'CTTCCode',
         type : 'string'
        }, {
         name : 'CTTCDesc',
         mapping : 'CTTCDesc',
         type : 'string'
        }, {
         name : 'CTTCSynonym',
         mapping :'CTTCSynonym',
         type:'string'
        },{
         name:'CTTCUnits',
         mapping:'CTTCUnits',
         type:'string' 
        },{
         name:'CTTCResultFormat',
         mapping:'CTTCResultFormat',
         type : 'string',
         render:function(v){
              if (v=='Reactions'){return 'B1';}
              if (v=='Blood Group') {return 'B2'} 
              if (v=='Antibodies'){return 'B3';}
              if (v=='Antigens') {return 'B4'} 
              if (v=='AuditControl'){return 'A';}
              if (v=='CoagControl') {return 'C'} 
              if (v=='Standard Comment'){return 'S';}
              if (v=='Free Text') {return 'X'} 
              if (v=='Numeric'){return 'N';}
              if (v=='Micro Pathogen') {return 'V'} 
              
               if (v=='Number *1000 or +') {return 'M'} 
              if (v=='Date'){return 'D';}
              if (v=='Time') {return 'T'} 
              if (v=='Yes/No'){return 'Y';}
              if (v=='Day Book Accession Number') {return 'Z1'} 
              if (v=='Day Book Site'){return 'Z2';}
              if (v=='Specimen Unlabeled') {return 'Z3'} 
              if (v=='Cancer Council Codes'){return 'Z4';}
              if (v=='Day Book Specimen type') {return 'Z5'} 
         }
        }, {
         name :'CTTCResultLength',
         mapping :'CTTCResultLength',
         type : 'string'
        },{
         name :'CTTCTestMethodDR',
         mapping :'CTTCTestMethodDR',
         type : 'string'
        }, {
         name :'CTTCShowInCummulative',
         mapping :'CTTCShowInCummulative',
         type : 'string'
        }]),
    defaultType : 'textfield',
    items : [ 
     {
       fieldLabel : '<font color=red>*</font>代&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码',
       allowBlank:false,
       regexText:"代码不能为空",
       name : 'CTTCCode',
       id:'CTTCCodeF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCCodeF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCCodeF')) /*  ,
       enableKeyEvents : true,
       validationEvent : 'blur',  
                            validator : function(thisText){
                           if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                           return true;
                           }
                             var className =  "web.DHCBL.CT.CTTestCode";   
                             var classMethod = "FormValidate"; //数据重复验证后台函数名                             
                             var id="";
                             if(win.title=='修改'){  
                              var _record = grid.getSelectionModel().getSelected();
                              var id = _record.get('RNAVRowId');  
                             }
                             var flag = "";
                             var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
                             if(flag == "1"){   
                               return false;
                              }else{
                               return true;
                              }
                            },
                            invalidText : '该代码已经存在',
          listeners : {
                       'change' : Ext.BDP.FunLib.Component.ReturnValidResult
          }
          */
      }, {
       fieldLabel : '<font color=red>*</font>描&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述',
       allowBlank:false,
       regexText:"描述不能为空",
       name : 'CTTCDesc',
       id:'CTTCDescF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCDescF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCDescF')) /* ,
       enableKeyEvents : true,
       validationEvent : 'blur',
                            validator : function(thisText){
                             if(thisText==""){  
                              return true;
                             }
                             var className =  "web.DHCBL.CT.CTTestCode"; //后台类名称
                             var classMethod = "FormValidate"; //数据重复验证后台函数名
                             var id="";
                             if(win.title=='修改'){ 
                              var _record = grid.getSelectionModel().getSelected();
                              var id = _record.get('RNAVRowId');  
                             }
                             var flag = "";
                             var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
                             if(flag == "1"){   
                               return false;
                              }else{
                               return true;
                              }
                            },
                            invalidText : '该描述已经存在',
         listeners : {
                       'change' : Ext.BDP.FunLib.Component.ReturnValidResult
          }
          */
      },{
       fieldLabel : '<font color=red>*</font>缩&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;写',
       name : 'CTTCSynonym',
       id:'CTTCSynonymF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCSynonymF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCSynonymF')) 
      
      },{
       fieldLabel : '<font color=red>*</font>单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;位',
       name : 'CTTCUnits',
       id:'CTTCUnitsF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCUnitsF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCUnitsF')) 
      },
     {
       xtype:'combo',
       fieldLabel:'结果格式',
       id:'CTTCResultFormat',
       name:'CTTCResultFormat',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCResultFormat'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCResultFormat')),
       store:new Ext.data.SimpleStore({
        fields:['CTTCResultFormat','value'],
        data:[   
               ['B1','Reactions'],
               ['B2','Blood Group'],
               ['B3','Antibodies'],
               ['B4','Antigens'],
               ['A','AuditControl'],
               ['C','CoagControl'],
               ['S','Standard Comment'],
               ['X','Free Text'],
               ['N','Numeric'],
               ['V','Micro Pathogen'],
               ['M','Number *1000 or +'],
               ['D','Date'],
               ['T','Time'],
               ['Y','Yes/No'],
               ['Z1','Day Book Accession Number'],
               ['Z2','Day Book Site'],
               ['Z3','Specimen Unlabeled'],
               ['Z4','Cancer Council Codes'],
               ['Z5',' Day Book Specimen type'],
               ['Z6',' Day Book Specimen type'],
               ['Z7',' 24 Hour Urine Volume'],
               ['Z8','24 Hour Urine Time'],
               ['Z9','Theraputic drug dosage'],
               ['Z10',' Theraputic drug duration'],
               ['Z11','Snomed Codes'],
               ['Z12',' Date of last XM'],
               ['Z13','Date of last AB Register'],
               ['Z14',' Weeks pregnant'],
               ['Z15','Serum Hold Date'],
               ['Z16',' Last Transfusion Date'],
               ['Z17','Anatomical Site'],
               ['Z18',' Specimen Type'],
               ['Z19','Fasting status'],
               ['Z20','ALL DayBook Accession Numbers'],
               ['Z21','Aerobic Bottle Number'],
               ['Z22','Anaerobic Bottle Number'],
               ['B4','Final Line of Diagnosis'] 
             ]
       }),
       displayField:'value',
       valueField:'CTTCResultFormat',
       mode:'local',
       triggerAction:'all',
       blankText:'请选择'
       
      },{
       fieldLabel : '精确度',
       name :'CTTCShowInCummulative',
       id:'CTTCShowInCummulativeF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCShowInCummulativeF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCShowInCummulativeF')),
       allowBlank:true 
      }, {
       fieldLabel : '&nbsp;结果长度',
       name : 'CTTCResultLength',
       id:'CTTCResultLengthF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTCResultLengthF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTCResultLengthF')) 
      },{
      fieldLabel : '&nbsp;方法',
       name : 'CTTC_TestMethod_DR',
       id:'CTTC_TestMethodDRF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTTC_TestMethodDRF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTTC_TestMethodDRF')) 
      
      }]
   });
 /******************************* 增加修改时弹出窗口*********************************/
 var win = new Ext.Window({
  title : '',
  width : 380,
  height : 350,
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
  labelWidth : 55,
  items : WinForm,
  buttons : [{
   text : '保存',
   id:'save_btn',
   disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
   handler : function AddData() {
   var tempCode = Ext.getCmp("form-save").getForm().findField("CTTCCode").getValue();
   var tempDesc = Ext.getCmp("form-save").getForm().findField("CTTCDesc").getValue();
  
   if (tempCode=="") {
    Ext.Msg.show({ 
        title : '<font color=blue>提示</font>',
        msg : '<font color=red>代码不能为空!</font>', 
        minWidth : 200,
        icon : Ext.Msg.ERROR, 
        animEl: 'form-save',
        buttons : Ext.Msg.OK,
        fn:function()
        {
         Ext.getCmp("form-save").getForm().findField("CTTCCode").focus(true,true);
        }
       });
         return;
  }
   if (tempDesc=="") {
    Ext.Msg.show({
        title : '<font color=blue>提示</font>',
        msg : '<font color=red>描述不能为空!</font>',
        minWidth : 200,
        animEl: 'form-save',
        icon : Ext.Msg.ERROR,
        buttons : Ext.Msg.OK ,
        fn:function()
        {
         Ext.getCmp("form-save").getForm().findField("CTTCDesc").focus(true,true);
        }
        });
         return;
  }
    if (win.title == "添加") {
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
            msg : '<font color=green>添加成功!</font>',
            icon : Ext.Msg.INFO,
            buttons : Ext.Msg.OK,
            animEl: 'form-save',
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
           msg : '<font color=green>修改成功!</font>',
           icon : Ext.Msg.INFO,
           buttons : Ext.Msg.OK,
           animEl: 'form-save',
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
  },{
   text : '取消',
   handler : function() {
    win.hide();
   }
  }],
  listeners : {
   "show" : function() {
    Ext.getCmp("form-save").getForm().findField("CTTCCode").focus(true,300);
   },
   "hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
   "close" : function() {
   }
  }
 });
 /************************************* 增加按钮****************************************/
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
 /******************************修改按钮**********************************/
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
    /****************************检验项目关联备注维护**********************************************************************/
      var CTTestCodeStandardComments  = new Ext.Toolbar.Button({    // 6. 检验项目关联备注 
        text: '检验项目关联备注维护',
        iconCls: 'icon-useredit',
        tooltip: '检验项目关联备注维护',
        id:'CTTestCodeStandardComments',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('CTTestCodeStandardComments'),
        handler: function CTTestCodeStandardComments() {   
         alert("ss")
        }
 });
 /******************************检验项目范围************************************************************/
 var CTTestCodeRanges = new Ext.Toolbar.Button({    // 7. 检验项目范围
        text: '检验项目范围',
        iconCls: 'icon-useredit',
        tooltip: '检验项目范围',
        id:'CTTestCodeRanges',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('CTTestCodeRanges'),
        handler: function CTTestCodeRanges() { 
          alert ("dd")
    
        }
 });  
     
 /****************************************数据存储**************************************************/
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
         name : 'CTTCCode',
         mapping : 'CTTCCode',
         type : 'string'
        }, {
         name : 'CTTCDesc',
         mapping :'CTTCDesc',
         type:'string'
        },{
         name:'CTTCSynonym',
         mapping:'CTTCSynonym',
         type:'string' 
        },{
         name:'CTTCUnits',
         mapping:'CTTCUnits',
         type : 'String' 
        },{
         name:'CTTCResultFormat',
         mapping:'CTTCResultFormat',
         type : 'string'
        }, {
         name :'CTTCResultLength',
         mapping :'CTTCResultLength',
         type : 'string'
        },{
         name :'CTTCTestMethodDR',
         mapping :'CTTCTestMethodDR',
         type : 'string'
        }, {
         name :'CTTCShowInCummulative',
         mapping :'CTTCShowInCummulative',
         type : 'string'
        }
      ]),
    sortInfo:{field:'CTTCCode',direction:'ASC'}
   });
   /************************* 加载数据*********************************************/
 ds.load({
    params : {
     start : 0,
     limit : pagesize_main
    },
    callback : function(records, options, success) {
    }
   }); 
 /****************************数据分页设置********************************************/
 var paging = new Ext.PagingToolbar({
    pageSize : pagesize_main,
    store : ds,
    displayInfo : true,
    displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
    emptyMsg : "没有记录"
   })
 var sm = new Ext.grid.CheckboxSelectionModel({
    singleSelect : true,
    checkOnly : false,
    width : 20
   });
 /**********************************增删改工具条**************************************/
 var tbbutton = new Ext.Toolbar({
  enableOverflow : true,  
  items : [btnAddwin, '-', btnEditwin, '-', btnDel, '-',CTTestCodeStandardComments, '-', CTTestCodeRanges ]
  })
 /***********************************搜索工具条***************************************/
 var btnSearch = new Ext.Button({
    id : 'btnSearch',
    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
    iconCls : 'icon-search',
    text : '搜索',
    handler : function () {
    grid.getStore().baseParams={   
      code : Ext.getCmp("TextCode").getValue(),
      desc : Ext.getCmp("TextDesc").getValue() 
     //  active: Ext.getCmp("CTTCUnits").getValue() 
    };
    grid.getStore().load({
     params : {
		        start : 0,
		        limit : pagesize_main
		       }
		     });
		    }
		  });
 /*************************************刷新工作条*************************************/
 var btnRefresh = new Ext.Button({
    id : 'btnRefresh',
      disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
    iconCls : 'icon-refresh',
    text : '重置',
    handler : function refresh() {
     Ext.getCmp("TextCode").reset();
     Ext.getCmp("TextDesc").reset();
  //   Ext.getCmp("CTTCUnits").reset();
     grid.getStore().baseParams={};
     grid.getStore().load({
        params : {
		           start : 0,
		           limit : pagesize_main
		          }
		        });
		      }
		    });

 /*********************************** 将工具条放到一起*************************************/
 var tb = new Ext.Toolbar({
    id : 'tb',
    items : ['代码:', {
       xtype : 'textfield',
       id : 'TextCode',
       disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
     },// '-',
     '描述:', {
       xtype : 'textfield',
       id : 'TextDesc',
       disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
    },'-', btnSearch, '-', btnRefresh, '-'
    ],
    listeners : {
     render : function() {
     tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
     }
    }  
  });
     
     /*  
    ,'CTTCUnits',{
       id : 'CTTCUnits',
       disabled : Ext.BDP.FunLib.Component.DisableFlag('CTTCUnits'),
       xtype : 'combo',
       width : 140,
       mode : 'local',
       editable:false,
       store : new Ext.data.SimpleStore({
       fields : ['value', 'text'],
       data : [
         ['F', 'Functional'],
         ['S', 'Structural']
         ]}),
       triggerAction : 'all',
       forceSelection : true,
       selectOnFocus : false,
       typeAhead : true,
       minChars : 1,
       listWidth : 140,
       valueField : 'value',
       displayField : 'text' ,
        listeners:{
               'select':  function(){
                grid.getStore().baseParams={   
       active: Ext.getCmp("CTTCUnits").getValue()
    };
    grid.getStore().load({
          params : {
             start : 0,
             limit : pagesize_main
            }
         });
               }
           }    
      }*/
  
   
   
/************************************创建表格*************************************************/
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
    columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
      { /// ,,,)
       header : '代码',
       width : 120,
       sortable : true,
       renderer: Ext.BDP.FunLib.Component.GirdTipShow,
       dataIndex : 'CTTCCode'
      }, {
       header : '描述',
       width : 120,
       sortable : true,
       renderer: Ext.BDP.FunLib.Component.GirdTipShow,
       dataIndex : 'CTTCDesc'
      }, {
       header : '缩写',
       width : 120,
       sortable : true,
       dataIndex : 'CTTCSynonym' 
      },{
       header : '单位',
       width : 120,
       sortable : true,
       dataIndex :'CTTCUnits'
      }, {
       header : '结果格式',
       width : 120,
       sortable : true,
       dataIndex : 'CTTCResultFormat'
      },{
       header : '精确度',
       width : 120,
       sortable : true,
       dataIndex : 'CTTCShowInCummulative'
      },{
       header : '长度',
       width : 120,
       sortable : true,
       dataIndex :'CTTCResultLength'
      },{
       header : '方法',
       width : 120,
       sortable : true,
       dataIndex :'CTTCTestMethodDR'
      }],
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    stripeRows : true,
    columnLines : true, //在列分隔处显示分隔符
    loadMask : {
     msg : '数据加载中,请稍候...'
    },
    title : '检验项目',
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
 
  
/**********************************双击事件************************************************/
   var loadFormData = function(grid){
         var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
         if (!_record) {
             Ext.Msg.alert('修改操作', '请选择要修改的一项!');
         } else {
           WinForm.form.load( {
                 url : OPEN_ACTION_URL + '&code='+ _record.get('CTTCCode'),  //id 对应OPEN里的入参
                 success : function(form,action) {
          },
                 failure : function(form,action)
                 {
                 }
             });
         }
     };
     grid.on("rowdblclick", function(grid, rowIndex, e) {
       var row = grid.getStore().getAt(rowIndex).data;     
	    win.setTitle('修改');      ///双击后
	    win.setIconClass('icon-update');
	    win.show('');
	    loadFormData(grid);
     }); 
    

     
 var viewport = new Ext.Viewport({
    layout : 'border',
    items : [grid]
   });

});
