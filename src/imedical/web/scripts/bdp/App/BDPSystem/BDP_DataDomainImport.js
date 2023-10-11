    /// 名称:数据导入功能
    /// 编写者:基础数据平台组 - 
    /// 编写日期:2017-06-13
Ext.onReady(function() {
    var ReadExcel=function (efilepath,sheet_from,sheet_to,row_from,importclassname,importmethod)
    {   
        try{
            var oXL = new ActiveXObject("Excel.application"); 
            var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);
        }       
        catch(e){
            var emsg="请在IE下操作，并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
            Ext.Msg.show({
                title : '提示',
                msg : emsg ,
                minWidth : 200,
                icon : Ext.Msg.INFO,
                buttons : Ext.Msg.OK
            }) 
            return;
        }
            var errorMsg="";//错误信息
            for(var sheet_id=sheet_from;sheet_id<=sheet_to;sheet_id++) {
                var errorRow="";//没有插入的行
                var updateRow="";
                var skipRow="";
                var errorMsg="";
                oWB.worksheets(sheet_id).select(); 
                var oSheet = oWB.ActiveSheet; 
                var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ;  ///行数
                var colcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count ;  ///列数
                var sheetname=oSheet.name;  //获取sheet的表名
                var str=oSheet.name+"sheet导入完成。";
               
                Ext.MessageBox.wait('正在导入'+oSheet.name+'数据，请勿刷新或关闭页面，请稍候...','提示');
                 //从第4行开始读取
                for(var i=row_from;i<=rowcount;i++){
    
                    var tempStr="";  //每行数据（第一列&第二列&...）
                    for (var j=1;j<=colcount;j++){
                        var cellvalue="";
                        if (typeof(oSheet.Cells(i,j).value)=="undefined")
                        {
                            var cellvalue="";
                        }
                        else
                        {
                            var cellvalue=oSheet.Cells(i,j).value;
                        }
                        if (tempStr=="")
                        {
                            tempStr=cellvalue;
                            if (tempStr=="")
                            {
                                tempStr="#";
                            }
                        }
                        else
                        {
                            tempStr=tempStr+("#"+cellvalue);
                        }
                    }
                    var Flag =tkMakeServerCall(importclassname,importmethod,sheetname,tempStr);
                    if (Flag=="0"){  //保存失败
                        if(errorRow!=""){
                            errorRow=errorRow+","+i
                        }else{
                            errorRow=i
                        }
                    }
                   
                if(errorRow!=""){
                    str=str+"第"+errorRow+"行插入失败。";
                }
                
                Ext.MessageBox.hide();
            }
             alert(str)
            oWB.Close(savechanges=false);
            oXL.Quit(); 
            CollectGarbage();
            oXL=null;
            oSheet=null;    
    }
  }  
    ///从excel导入
  var ExcelImport=function (){
        var efilepath=Ext.getCmp("ExcelImportPath").getValue();
        if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
        if( efilepath.indexOf(".xls")<=0 ) {alert ("请选择excel表格文件！"); return;}
        
        var sheet_from=1,sheet_to=1,row_from=2;
        var importclassname="web.DHCBL.CT.BDPNationalDataDomain",importmethod="ImportExcel";  //导入 数据
        ReadExcel(efilepath,sheet_from,sheet_to,row_from,importclassname,importmethod);
  }
    
    var formSearch = new Ext.form.FormPanel({
        title:'导入数据',
        frame:true,
        border:false,
        region: 'center',
        autoScroll:true,
        width:600,
        height:200,
        split: true,
        buttonAlign:'center',
        items:[{
            xtype: 'fieldset',
            title:'从Excel文件导入',
            labelWidth:120,     
            labelAlign:'right',
            autoHeight: true,
            width:700,
            defaultType:'textfield',
            items:[  
            {width: 400,fieldLabel:'导入Excel文件',xtype : 'textfield',inputType:'file',id : 'ExcelImportPath'},
            {iconCls : 'icon-import',text:'导入',xtype : 'button',
                listeners : {
                    "click" : function() {  
                        ExcelImport();   
                    }
                }
            }
            ]
        },
        {
              title:"备注说明",
              width:700,
              html : "<ui><li>1.导入时需选择正确的xls/xlsx格式的文件。</li></ui> <ui><li>2.需在IE下执行操作,并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用。</li></ui> <ui><li>3.导入的为User.DHCTarItem（收费项）这个表的数据。Excel文件导入原则：code相同的数据，如果与原数据库完全相同则跳过，code不同的数据新增，方便更新数据</li></ui> "
                
        }]
      }); 
    // 创建viewport
    var viewport = new Ext.Viewport({
                layout : 'border',
                items : [formSearch]
    });
  });

    
