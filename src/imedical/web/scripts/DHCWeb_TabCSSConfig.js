////DHCWeb_TabCSSConfig.js

////Load css Link 
document.write("<link rel='stylesheet' type='text/css' href='../scripts/DHCWeb_CSSOPCharge.CSS'></link>");
//document.write("<link rel='stylesheet' type='text/css' href='../scripts/test.css'></link>");

function DHCWebTabCSS_SetRowColorByCol(TabName,ColStr, ValStr, CSSNameStr, ExpStr){
	///tabname
	///col Ary 
	///Val Ary
	///CssName
	var objtbl=document.getElementById(TabName);
	var myRows=DHCWeb_GetTBRows(TabName);
	var mylastrow=0;
	var mycurrow=0;
	var ColAry=ColStr.split("^");
	var ValAry=ValStr.split("^");
	var CSSNameAry=CSSNameStr.split("^");
	var mycsslastidx=0;

	try{
		for(var i=1;i<=myRows;i++){
			var eSrc=objtbl.rows[i];
			var mycurrowobj=getRow(eSrc);
			
			var myTranFlag=true;
			var myvaldifflag=false;
			var mycollen=ColAry.length;
			///var mycollen=ColAry.length;
			for (var j=0;j<mycollen;j++){
				var mycurobj=document.getElementById(ColAry[j]+"z"+i);
				///var mycurval=DHCWebD_GetCellValue(mycurobj);
				var mycurval=DHCWebD_GetCellValueB(mycurobj);
				if((mycurval!=ValAry[j])||(mycurval=="")){				
					myTranFlag=false;
					break;
				}
			}
			
			mylastrow=i;
			if (myTranFlag){
				if(myvaldifflag){
					if((mycsslastidx+1)==CSSNameAry.length){
						mycsslastidx=0;
					}else{
						mycsslastidx=mycsslastidx+1;
					}
				}
				mycurrowobj.className=CSSNameAry[mycsslastidx];
			}
		}
	}catch(e){
		alert(e.message);
	}
	
}

function DHCWebTabCSS_SetRowColorCycle(TabName,ColStr, ValStr, CSSNameStr, EmpNFlag, ExpStr){
	var objtbl=document.getElementById(TabName);
	var myRows=DHCWeb_GetTBRows(TabName);
	var mylastrow=0;
	var mycurrow=0;
	var ColAry=ColStr.split("^");
	var ValAry=ValStr.split("^");
	var CSSNameAry=CSSNameStr.split("^");
	var mycsslastidx=0;
	var PressNOAry=new Array();
	try{
		//var colorNum=0;
		var colorNum=2;
		for(var i=1;i<=myRows;i++){
			var eSrc=objtbl.rows[i];
			var mycurrowobj=getRow(eSrc);
			var myOPOrdPrescNo=GetColumnData2("OPOrdPrescNo",i);
			if(myOPOrdPrescNo!=""){
				if(!CSSNameAry[myOPOrdPrescNo]){
					//colorNum=colorNum+1;	//¶àÖÖÑÕÉ«
					if(colorNum==1){
						colorNum=2;
					}else{
						colorNum=1;
					}
					CSSNameAry[myOPOrdPrescNo]="OPOELPrescNo"+colorNum;	
				}
				mycurrowobj.className=CSSNameAry[myOPOrdPrescNo];
				//mycurrowobj.style.color="red";
			}	
		}
	}catch(e){
		alert(e.message);
	}
	
}

function GetColumnData2(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){
				return CellObj.checked;
			}else{
				return CellObj.value
			}
		}
	}
	return "";
}

function DHCWebTabCSS_SetRowColorCycleOLD(TabName,ColStr, ValStr, CSSNameStr, EmpNFlag, ExpStr){
	///tabname
	///col Ary
	///Val Ary
	///CssName Ary
	///EmpNFlag				///treat with Empty Str  prior first
	
	var objtbl=document.getElementById(TabName);
	var myRows=DHCWeb_GetTBRows(TabName);
	var mylastrow=0;
	var mycurrow=0;
	var ColAry=ColStr.split("^");
	var ValAry=ValStr.split("^");
	var CSSNameAry=CSSNameStr.split("^");
	var mycsslastidx=0;
	
	try{
		for(var i=1;i<=myRows;i++){
			var eSrc=objtbl.rows[i];
			var mycurrowobj=getRow(eSrc);
			
			var myTranFlag=true;
			var myvaldifflag=false;
			var mycollen=ColAry.length;
			///var mycollen=ColAry.length;
			for (var j=0;j<mycollen;j++){
				if (i==1){
					var mylastobj=document.getElementById(ColAry[j]+"z"+i);
				}else{
					var mylastobj=document.getElementById(ColAry[j]+"z"+(i-1));
				}
				
				var mycurobj=document.getElementById(ColAry[j]+"z"+i);
				var mylastval=DHCWebD_GetCellValue(mylastobj);
				
				var mycurval=DHCWebD_GetCellValue(mycurobj);
				if ((EmpNFlag)&&(mycurval=="")){
					myTranFlag=false;
					break;
				}
				if ((mylastval!=mycurval)){
					///trans CSSAry
					myvaldifflag=true;
				}
			}
			mylastrow=i;
			if (myTranFlag){
				if(myvaldifflag){
					if((mycsslastidx+1)==CSSNameAry.length){
						mycsslastidx=0;
					}else{
						mycsslastidx=mycsslastidx+1;
					}
				}
				mycurrowobj.className=CSSNameAry[mycsslastidx];
			}
		}
	}catch(e){
		alert(e.message);
	}
}

function DHCWebTabCSS_InitTab(){
	var mywinname=window.name;
	var myVersion=DHCWebD_GetObjValue("DHCVersion");
	switch(myVersion){
		case "0":
			////(TabName,ColStr, ValStr, CSSNameStr, EmpNFlag, ExpStr)
			var myTabName="t"+mywinname;
			var myColStr="OPOrdPrescNo";
			var myValStr="";
			///var myCSSNameStr="JSTPrescBlockSelect1^JSTPrescBlockSelect2";
			var myCSSNameStr="OPOELPrescNo1^OPOELPrescNo2";
			var myEmpNFlag=true;
			var myExpStr="";
			
			DHCWebTabCSS_SetRowColorCycle(myTabName, myColStr, myValStr, myCSSNameStr, myEmpNFlag, myExpStr);
			break;
		case "4":
			break;
		default:
		//case "9":
			////(TabName,ColStr, ValStr, CSSNameStr, EmpNFlag, ExpStr)
			var myTabName="t"+mywinname;
			var myColStr="OPOrdPrescNo";
			var myValStr="";
			///var myCSSNameStr="JSTPrescBlockSelect1^JSTPrescBlockSelect2";
			var myCSSNameStr="OPOELPrescNo1^OPOELPrescNo2";
			var myEmpNFlag=true;
			var myExpStr="";
			
			DHCWebTabCSS_SetRowColorCycle(myTabName, myColStr, myValStr, myCSSNameStr, myEmpNFlag, myExpStr);
		//	break;
			/*
		default:
			///
			var myTabName="t"+mywinname;
			var myColStr="LimitFlag";
			var myValStr="Y";
			
			var myCSSNameStr="OPOECHLimPrescNo";
			var myExpStr="";
			DHCWebTabCSS_SetRowColorByCol(myTabName,myColStr, myValStr, myCSSNameStr, myExpStr);			
			*/
	}
	
}