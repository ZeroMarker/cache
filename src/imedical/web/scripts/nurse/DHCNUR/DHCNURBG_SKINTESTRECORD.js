/*
	注:如果有修改界面模版重新生成js,需要手动增加界面js 记录人密码和核对人密码的 inputType:'password'
	{header:'记录人密码',dataIndex:'RecPassword',width:92,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false,inputType:'password'}))}
	{header:'核对人密码',dataIndex:'RecAuditPassword',width:96,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false,inputType:'password'}))}
*/

var recUserId="",auditUserId="";
function BodyLoadHandler()
{
	setsize("mygridpl","gform","mygrid");
	grid=Ext.getCmp('mygrid');
    grid.setTitle(changeFontSize("皮试记录单"));
	
    var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
	var but2=Ext.getCmp("mygridbut2");
	but2.setText(changeFontSize("保存"));
	but2.on('click',save);
	var mydate=new Date();
	var tobar=grid.getTopToolbar();
	tobar.addItem("-",changeFontSize("开始日期："),{xtype:'datefield',format: 'Y-m-d',id:'mygridstdate',value:admDate},
								"-",
	    					changeFontSize("结束日期："),{xtype:'datefield',format: 'Y-m-d',id:'mygridenddate',value:diffDate(new Date(),1)},"-");
	tobar.addButton({width:50,text: "查询",icon:'../images/uiimages/search.png',handler: find});
	tobar.addButton({width:50,text: "删除",icon:'../images/uiimages/cancel.png',handler: deleteFn});
	tobar.addButton({width:80,text: "打印",icon:'../images/uiimages/print.png',handler: printFn});
    
	tobar.doLayout();
	
	grid.addListener("afterEdit",check);
	
	Ext.override(Ext.Editor, {
		onSpecialKey : function(field, e) {
			var key = e.getKey();
			this.fireEvent('specialkey', field, e);
		}
	});
    Ext.override(Ext.grid.RowSelectionModel, {
		onEditorKey : function(F, E) {
			var C = E.getKey(), G, D = this.grid, B = D.activeEditor;
			var A = E.shiftKey; 
			//debugger;
			if (C == E.RIGHT) {
				// alert();
				E.stopEvent();
				B.completeEdit();
				G = D.walkCells(B.row,B.col+1, 1, this.acceptsNav,this);
			}  
			if (C == E.LEFT) {
				// alert();
				E.stopEvent();
				B.completeEdit();
				G = D.walkCells(B.row,B.col-1, 1, this.acceptsNav,this);
			}
			if (C == E.DOWN) {
				// alert();
				E.stopEvent();
				B.completeEdit();
				G = D.walkCells(B.row+1,4, 1, this.acceptsNav,this);
			}    
			if (C == E.UP) {
				// alert();
				E.stopEvent();
				B.completeEdit();
				G = D.walkCells(B.row-1,4, 1, this.acceptsNav,this);
			}
			if (C == E.TAB) {
				E.stopEvent();
				B.completeEdit();
				if (A) {
					G = D.walkCells(B.row, B.col - 1, -1, this.acceptsNav,
								this);
				} else {
					G = D.walkCells(B.row, B.col + 1, 1, this.acceptsNav,
								this);
				}
			} else {
				if (C == E.ENTER) {
					E.stopEvent();
					// alert(B);
					B.completeEdit();
					
					/*if((B.col==6)||(B.col==8))
					{
						getUser(B.col);
					}*/
					if (this.moveEditorOnEnter !== false) {
						if (A) {
							// G = D.walkCells(B.row - 1, B.col, -1,
							// this.acceptsNav,this)
							G = D.walkCells(B.row, B.col - 1, -1,
										this.acceptsNav, this);
						} else {
							// G = D.walkCells(B.row + 1, B.col, 1,
							// this.acceptsNav,this)
							G = D.walkCells(B.row, B.col + 1, 1,
										this.acceptsNav, this);
						}
					}
				} else {
					if (C == E.ESC) {
						B.cancelEdit();
					}
				}
			}
			if (G) {
				D.startEditing(G[0], G[1]);
			}
		}
	});
	grid.store.on("beforeLoad",BeforeLoad);
	find();
}

function BeforeLoad()
{
	var stDate = Ext.getCmp("mygridstdate");
	var endDate = Ext.getCmp("mygridenddate");
	grid.store.baseParams.stDate=stDate.value;
	grid.store.baseParams.endDate=endDate.value; 
	grid.store.baseParams.regNo=regNo; 
	
}

function find()
{
	grid=Ext.getCmp('mygrid');
	grid.store.load({params:{start:0,limit:1000}});
}

function additm()
{ 
  	var Plant = Ext.data.Record.create([
	{name:'RecDate'}, 
	{name:'RecTime'},
	{name:'RecRegNo'},
	{name:'RecOrdName'},
	{name:'RecLocDesc'},
	{name:'RecUser'},
	{name:'RecPassword'},
	{name:'RecAuditUser'},
	{name:'RecAuditPassword'},
	{name:'RecNote'},
	{name:'RecExt'},
	{name:'Id'}
      ]);
	
    var count = grid.store.getCount(); 
    var r = new Plant({RecDate:new Date(),RecTime:new Date().dateFormat('H:i'),RecRegNo:regNo,RecOrdName:arcimDesc,RecLocDesc:locDesc}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
	return;
}

function check()
{
	var mGrid = this.id;
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var recUser="",recPassword="",recAuditUser="",recAuditPassword="";
	for (var i = 0; i < len; i++) {
	    
		var obj=rowObj[i].data;
		for (var p in obj) {
			if (p=="") continue;				
			if (p=="RecUser") recUser=obj[p];
			if (p=='RecPassword') recPassword=obj[p];
			
			if (p=="RecAuditUser") recAuditUser=obj[p];
			if (p=='RecAuditPassword') recAuditPassword=obj[p];
		}
	}
	if((recUser!="")&&(recPassword!=""))
	{
		getUser(6);
	}
	
	if((recAuditUser!="")&&(recAuditPassword!=""))
	{
		getUser(8);
	}
	
}


function getUser(col)
{
	var userCode="",userPassword="",userId="";
	var rowObj = grid.getSelectionModel().getSelections();
	for (var i = 0; i < rowObj.length; i++) {
	    var obj=rowObj[i].data;  
		for (var p in obj) {
			if(col==6)
			{
				if((p!="RecUser")&&(p!="RecPassword"))
				{
					continue;
				}
				if(p=="RecUser")
				{
					userCode=obj["RecUser"];
				} 
				if(p=="RecPassword")
				{
					userPassword=obj["RecPassword"];
					obj["RecPassword"]="" ;
				} 
				
			}
			else if(col==8)
			{
				if((p!="RecAuditUser")&&(p!="RecAuditPassword"))
				{
					continue;
				}
				if(p=="RecAuditUser") userCode=obj["RecAuditUser"];
				if(p=="RecAuditPassword")
				{
					userPassword=obj["RecAuditPassword"];
					obj["RecAuditPassword"]="" ;
				} 
			}
		}
	}
	//alert(userCode)
	//alert(userPassword)
	var ret=tkMakeServerCall("web.DHCLCNUREXCUTE","ConfirmPassWord",userCode,userPassword);
	//alert(ret)
	if(ret.split("^")[0]!=0)
	{
		if(col==6) alert("记录人:"+ret);
		if(col==8) alert("核对人:"+ret);
		grid.store.commitChanges();
		return;
	}
	else{
		userId=ret.split("^")[1];
		if(col==6) recUserId=userId;
		if(col==8) auditUserId=userId;
	}
	
	var userName=tkMakeServerCall("web.DHCNurCom","getUserName",userId);
	for (var i = 0; i < rowObj.length; i++) {
	    var obj=rowObj[i].data;  
		for (var p in obj) {
			if(col==6)
			{
				if((p!="RecUser")&&(p!="RecUserId"))
				{
					continue;
				}
				if(p=="RecUser") obj["RecUser"]=userName;
				if(p=="RecUserId") obj["RecUserId"]=userId;
			}
			else if(col==8)
			{
				if((p!="RecAuditUser")&&(p!="RecAuditUserId"))
				{
					continue;
				}
				if(p=="RecAuditUser") obj["RecAuditUser"]=userName;
				if(p=="RecAuditUserId") obj["RecAuditUserId"]=userId;
			}
		}
	}
	grid.store.commitChanges();
	
}

function save()
{
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//var locId=""
	if(len==0)
	{
		alert("请选择一条记录!");
		return;
	}
	
	if(recUserId=="")
	{
		alert("请确认记录人再保存!");
		return;
	}
	
	if(auditUserId=="")
	{
		alert("请确认核对人再保存!");
		return;
	}
	var par=EpisodeID+"^"+oeoriId+"^"+regNo+"^"+ctlocId+"^"+recUserId+"^"+auditUserId
	var saveRet="0";
	for (var i = 0; i < len; i++) {
	    
		var obj=rowObj[i].data;
	    var gridStr="";
	    var CareDate="";
	    var CareTime="";

		for (var p in obj) {
			var aa = formatDate(obj[p]);				
			if (p=="RecDate") CareDate=aa;
			if (p=='RecTime') CareTime=obj[p];
			if (p=="") continue;
			
			if (aa == "") 
			{
				gridStr = gridStr + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	gridStr = gridStr + p + "|" + aa + '^';	
			}
		}
		if (gridStr!="")
		{
			if (gridStr.indexOf("RecDate")==-1)
			{
				gridStr=gridStr+"RecDate|"+CareDate+"^RecTime|"+CareTime;
			}
			var a=tkMakeServerCall("Nur.SkinTestRecord","Save",par,gridStr);
			saveRet=a;
			if (a!="0")
			{
				alert(a);
				return;
			}
			
		}
	}
	if(saveRet=="0")
	{
		alert("保存成功!");
		recUserId="";
		auditUserId="";
	}
	find();
}

function deleteFn()
{
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	else
	{
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '您确定要删除该条记录吗?',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){    
					var id=objRow[0].get("Id");
					var a=tkMakeServerCall("Nur.SkinTestRecord","deleteRec",id,session['LOGON.USERID']);
					if (a!=0){
						alert(a);
						return;
					}else{
						find();
					}
					
	            }    
	        }    
	    });
	}
}

function formatDate(value){
    try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
}

function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (i = 0; i < str.length; i++) {
			code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else{
		result=str;
	}  
	return result;   
}

function printFn()
{
	//alert("打印")
	//alert(EpisodeID)
	PrintCommPic.TitleStr=tkMakeServerCall("web.DHCMGNurComm","PatInfo",EpisodeID);
	PrintCommPic.SetPreView("1");											//打印时是否预览：1预览，0不预览
	PrintCommPic.WebUrl=window.dialogArguments.session['WebIP']+"/dthealth/web/DWR.DoctorRound.cls";
	PrintCommPic.stPage=0;
	PrintCommPic.stRow=0;
	PrintCommPic.previewPrint="1"; 										//是否弹出设置界面
	PrintCommPic.stprintpos=0;
	PrintCommPic.dxflag = 1; 											//分割线设置：1一条记录打印一条线 0 一行打印一条线
	PrintCommPic.ItmName = "DHCNURMouldPrn_PSJLDPRINT"; //打印模板				
	PrintCommPic.previewPrint = "0"; 									//是否弹出设置界面:0不弹出，1弹出   
	var stDate = Ext.getCmp("mygridstdate").value;
	var endDate = Ext.getCmp("mygridenddate").value;
	// 注：加 EpisodeID	和 DHCNURBG_SKINTESTRECORD是为了使调用护理病历打印程序不报错			注意不要少了最后一个！
	// 加载后台数据有用参数就 stDate    endDate   regNo
	var parr = EpisodeID + "!" + stDate + "!" + endDate + "!" + regNo + "!" + "" + "!" + "DHCNURBG_SKINTESTRECORD" + "!"; 
	PrintCommPic.ID = "";	
	PrintCommPic.MultID = "";
	PrintCommPic.SetParrm(parr);
	PrintCommPic.PrintOut();
}

function changeFontSize(str)
{
	
	return '<span style="font-size:15px;">'+str+'</span>'
}

function changeFontSizeBySize(str,size)
{
	
	return '<span style=font-size:'+size+'px;>'+str+'</span>'
}
