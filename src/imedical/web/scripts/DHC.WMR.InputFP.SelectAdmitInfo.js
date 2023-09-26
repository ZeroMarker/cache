//Select AdmitInfomation
var objSelAdmWin = null;
var strAdmitDate = "住院日期";
var strAdmitTime = "住院时间";
var strAdmitDep = "住院科室";
var strDischargeTime = "出院时间";
var strDischargeDate = "出院日期";
var strDischargeDep = "出院科室";
var strWard = "病房";
var strBed = "床号";
var strDocDesc = "医师";
var strTitle = "请选择就诊信息";
var strBtnOK = "确定";
var strBtnCancel = "取消";
var objSelAdmGrid = null;

function InitSelectAdminInfoWin()
{
        var store = new Ext.data.SimpleStore({
        fields: [
           {name: 'RowID'},
           {name: 'AdmType'},
           {name: 'AdmNo'},
           {name: 'AdmDate'},
           {name: 'AdmTime'},
           {name: 'papmi'},
           {name: 'LocDesc'},
           {name: 'DocDesc'},
           {name: 'WardDesc'},
           {name: 'RoomDesc'},
           {name: 'BedDesc'},
           {name: 'DischgDate'},
           {name: 'DischgTime'},
           {name: 'RelatiedObj'}
           
           //{name: 'lastChange', type: 'date', dateFormat: 'n/j h:ia'}
        ]
    });
   
    objSelAdmGrid = new Ext.grid.GridPanel({
        store: store,
        columns: [
            new Ext.grid.RowNumberer(),
            {id:'RowID', header: "ID", width: 0, sortable: false, hidden:true, dataIndex: 'RowID'},
            {header: strAdmitDate, width: 90, sortable: false, dataIndex: 'AdmDate'},
            {header: strAdmitTime, width: 90, sortable: false,  dataIndex: 'AdmTime'},
            {header: strDischargeDate, width: 90, sortable: false,  dataIndex: 'DischgDate'} ,           
            {header: strDischargeTime, width: 90, sortable: false,  dataIndex: 'DischgTime'} ,           
            {header: strDischargeDep, width: 90, sortable: false, dataIndex: 'LocDesc'},
            {header: strWard, width: 90, sortable: false, dataIndex: 'WardDesc'},
            {header: strBed, width: 90, sortable: false, dataIndex: 'BedDesc'},
            {header: strDocDesc, width: 90, sortable: false, dataIndex: 'DocDesc'}

            
        ],
        stripeRows: true,
        //autoExpandColumn: 'ICDCode',
        height:400,
        width:750
    }); 
   objSelAdmWin = new Ext.Window(    {
        title:strTitle,
                        layout:'fit',
                width:800,
                height:300,
                closeAction:'hide',
                plain: true,
        modal:true,
        items:[objSelAdmGrid],
        buttons:[
            {
                text:strBtnOK,
                handler: SelectAdmWinBtnOKOnClick
            },
            {
                text:strBtnCancel,
                handler:SelectAdmWinBtnCancelOnClick 
            }
        ]
       //width:900
        
    }); 
   objSelAdmGrid.on('keydown', objSelAdmGrid_OnKeyDown, objSelAdmWin); 
   objSelAdmWin.on('activate', objSelAdmWin_OnActive, objSelAdmWin);
  // window.alert("Before Show");
   objSelAdmWin.show(); 
   
   
   
   DisplayAdmInfo(null);
   //window.alert("AA");
   

}

function DisplayAdmInfo(objArry)
{
    objArry = new Array();
    var objVol = null;
    var objAdm = null;
   for(var i = 0; i < 10; i ++)
   {
        objVol = DHCWMRMainVolume();
        objVol.Adm = DHCWMRAdmInfo();
        objArry.push(objVol);
   } 
   
   var objStore = objSelAdmGrid.getStore();
   for(var i = 0; i < objArry.length ; i ++)
   {
        objVol = objArry[i];
        var objData =new Ext.data.Record({
           RowID:objVol.RowID,
           AdmType:objVol.Adm.AdmType,
           AdmNo:objVol.Adm.AdmNo,
           AdmDate:objVol.Adm.AdmDate,
           AdmTime:objVol.Adm.AdmTime,
           papmi:objVol.Adm.PatientID,
           LocDesc:objVol.Adm.LocDesc,
           DocDesc:objVol.Adm.DocDesc,
           WardDesc:objVol.Adm.WardDesc,
           RoomDesc:objVol.Adm.RoomDesc,
           BedDesc:objVol.Adm.BedDesc,
           DischgDate:objVol.Adm.DischgDate,
           DischgTime:objVol.Adm.DischgTime,
           RelatiedObj:objVol
         });
        objStore.add([objData]);
   }
   objSelAdmGrid.getSelectionModel().selectFirstRow();
}

function objSelAdmWin_OnActive(objEvent)
{
    //window.alert("Active");
   document.getElementById(objSelAdmGrid.getId()).focus(); 
}

function objSelAdmGrid_OnKeyDown(objEvent)
{
    window.alert("Down");
}

function SelectAdmWinBtnOKOnClick()
{
    window.alert("OK");
}

function SelectAdmWinBtnCancelOnClick()
{
    objSelAdmWin.hide();
}

Ext.onReady(InitSelectAdminInfoWin);

