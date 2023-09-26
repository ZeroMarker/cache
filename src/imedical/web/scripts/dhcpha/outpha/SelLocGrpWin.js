var win="";
//创建弹出窗体
function createWin()
{
	var rows = 4; //行数
	var cell = 3;
	var value = 1;
	var mytrn=tkMakeServerCall("web.DHCSTPHCMCOMMON","getLocGrpMan","359");  //session['LOGON.CTLOCID']
	var LocGrpStr=mytrn.split("//");

	var LocGrpArray = new Array(); //数组
	var Cnt=LocGrpStr.length; //科室组个数
	for(var m=0;m<Cnt;m++)
	{
		LocGrpArray[m]=new Array(); //初始化数组
		var SStr=LocGrpStr[m].split("&");
		LocGrpArray[m][0]=SStr[0];  //科室组描述
		LocGrpArray[m][1]=SStr[1];  //科室组对应明细科室
	}

	var rows = 0; //行数
	if(Cnt%3){ rows = 2*Math.ceil((Cnt/3));}
	else{ rows = 2*(Cnt/3) + 2;}
	
	if(rows<4){rows=4; }  //最少4行

	var grpIndex=0; var val="";var ind=0
	
	var inputstr='<input type="checkbox"/>';
	//外边框
	var htmlstr="";
	htmlstr='<div id="PageContent" height:"900">';
	htmlstr=htmlstr+'<table class="tbl" borderColor=#000000 height=40 cellPadding=1 width=930 align=center border=1 valign="top">';
    
    for(var i=0;i<rows;i++)
    {
        if(i%2){
	    	htmlstr=htmlstr+'<tr bgcolor="#F0F0F0" height="240px">';
	    	for(var j=0;j<cell;j++)
	    	{
		    	htmlstr=htmlstr+'<td style="BORDER: #4a4a84 1px dashed;">'
		    	//tb中的布局按照table设置(科室明细)
				htmlstr=htmlstr+'<table width="100%" height="100%">';
				if(ind>=Cnt){ var LocDetailArr="";}else{var LocDetailArr=LocGrpArray[ind][1].split("||");}

				for(var k=0;k<7;k++)
				{
					if((LocDetailArr=="")||(k>=LocDetailArr.length)){val="";}
					else{
						var tmpstr=LocDetailArr[k].split("^")
						val='<input id="'+tmpstr[0]+'"type="checkbox" name="'+"DM"+ind+'"/>'+"  "+tmpstr[1];
					}
					htmlstr=htmlstr+'<tr height="30px"><td>'+val+'</td></tr>';
				}
				htmlstr=htmlstr+'</table>';
		    	htmlstr=htmlstr+'</td>';
		    	ind=parseInt(ind)+1;
		    }
	    	htmlstr=htmlstr+'</tr>';
	    }else{
	    	htmlstr=htmlstr+'<tr bgcolor="#F0F0F0" height="30px" style="font-weight:bold">';
	    	for(var j=0;j<cell;j++)
	    	{
		    	if(grpIndex>=Cnt){ val="";}else{val='<input id="1" type="checkbox" name="'+"M"+grpIndex+'" onclick="javascript:AutoSelLoc('+grpIndex+')"/>'+"  "+LocGrpArray[grpIndex][0];}
		    	htmlstr=htmlstr+'<td style="BORDER: #4a4a84 1px dashed;">'+val+'</td>';
		    	grpIndex=parseInt(grpIndex)+1;
		    }
	    	htmlstr=htmlstr+'</tr>';
	    }
    }
    AutoSelLoc=function (arg1)
	{
		var obj=document.getElementsByName("M"+arg1); //科室组
		var checkflag=obj[0].checked;
		var objList=document.getElementsByName("DM"+arg1);  //科室组明细
		for(var n=0;n<objList.length;n++)
		{
			objList[n].checked=checkflag;
		}
	}
   	htmlstr=htmlstr+"</table>";
	htmlstr=htmlstr+'</div>';
	
    var sureButton = new Ext.Button({
         width : 65,
         id:"sureButton",
         align:'ligth',
         text: '确认',
         icon:"../scripts/dhcpha/img/update.png",
         listeners:{
                    "click":function(){
                        Submit();
                   }
         }
    })
	
	
	//窗体定义
	//var win = new Ext.Window({
	  win = new Ext.Window({
			width:950,
			height:600,
			title:"请选择审方科室",
			resizable:false,  //禁止设置窗体大小
			autoScroll: true, //自动显示滚动条
			//plain : true, //背景渲染
			modal : true,
			bbar:[sureButton]
	})
	win.html=htmlstr;
	win.show();
}

//确认提交
function Submit()
{
	var TempLocStr=""
	var objList=document.getElementsByTagName("input");  //input数组
	for(var n=0;n<objList.length;n++)
	{
		if(objList[n].name.indexOf("DM")!="-1"){
			//objList[n].checked="true";
			if(objList[n].checked){
				if(TempLocStr==""){TempLocStr=objList[n].id;}
				else{TempLocStr=TempLocStr+"^"+objList[n].id;}
			}
		}
	}
	if(TempLocStr==""){alert("请选择需审方科室！");return;}
	var ret=tkMakeServerCall("web.DHCSTPHCMCOMMON","SaveAudPreLocGrp",session['LOGON.USERID'],TempLocStr);
	if(ret!=""){
		alert(ret);
		return;}
	win.close();
	//FindWardList();
}
