/// DHCST.PIVA.COMMON.JS
/// 置tbl颜色
function SetTblRowsColor(objtbl,flag)
{
	var lregno="";
	var lmoeori="";
	var clsname="RowWhite";
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("selectz"+i);
		if (cell){cell.onclick=selectClick;}
		var cell=document.getElementById("tbSelectz"+i);
		if (cell){cell.onclick=tbSelectClick;}
		var objrow=objtbl.rows[i];
		var regno=""
		var objreg=document.getElementById("tbRegNoz"+i)
		if (objreg) regno=objreg.innerText
		if (regno!=lregno){
			if (clsname=="RowWhite") clsname="RowBlueGreen";
			else clsname="RowWhite";
			lregno=regno;
		}
		objrow.className=clsname
		var moeori=""
		if (flag==1){
			var objoe=document.getElementById("exestatusz"+i);
			if (objoe){
				oest=objoe.innerText
				if (oest=="停止"){
					objrow.className="RowPink"
				}
			}
			var objchemaudit=document.getElementById("auditstatusz"+i);
			if (objchemaudit){
				pass=objchemaudit.innerText
				if (pass=="审核拒绝"){
					objrow.className="Blue"
				}
			}
			var objoe=document.getElementById("mOeori"+"z"+i);
			//var objoe=document.getElementById("Tmdodis"+"z"+i);
	    	if (objoe) moeori=objoe.value;
	   	 	var objpaname=document.getElementById("paname"+"z"+i);
	    	var objstdate=document.getElementById("sttdate"+"z"+i);
	    	var objseq=document.getElementById("seqno"+"z"+i);
	    	//var objbed=document.getElementById("bed"+"z"+i);
	    	var objward=document.getElementById("ward"+"z"+i);
		}
		if (flag==2){
			var pno="";
			var objpno=document.getElementById("tbPrintNumz"+i);
			if (objpno){
				pno=objpno.innerText
				if (pno==""){
					objrow.className="Yellow"
				}
			}
			var objoe=document.getElementById("tbOeStatusz"+i);
			if (objoe){
				oest=objoe.innerText
				if (oest=="停止"){
					objrow.className="RowPink"
				}
			}
			
			var objoestcode=document.getElementById("tbOestateCodez"+i);
			if (objoestcode){
				oestcode=objoestcode.value
				if (oest=="D"){
					objrow.className="RowPink"
				}
			}
			
					
			var objspec=document.getElementById("tbSpecStatz"+i);
			if (objspec){
				spec=objspec.innerText
				if (spec=="R"){objrow.className="Blue";}
				else if(spec=="C"){objrow.className="Green";}
			}
			//var objoe=document.getElementById("tbMOeori"+"z"+i);
			var objoe=document.getElementById("tbMdodis"+"z"+i);
	    	if (objoe) moeori=objoe.value;
	   	 	var objpaname=document.getElementById("tbName"+"z"+i);
	    	var objstdate=document.getElementById("tbOexeDate"+"z"+i);
	    	var objseq=document.getElementById("tbSeqNo"+"z"+i);
	    	//var objbed=document.getElementById("tbBedNo"+"z"+i);
	    	var objward=document.getElementById("tbWard"+"z"+i);
		}
		
	    if (moeori==lmoeori){
			if(objstdate) objstdate.innerText="";
			if(objreg) objreg.innerText="";
		    if(objpaname) objpaname.innerText="";
		    if(objseq) objseq.innerText="";
		    //if(objbed) objbed.innerText="";
		    //if(objward) objward.innerText="";
	    }
	    else{
		   	lmoeori=moeori
	    }
	}
}
function InitSpecStat(listobj)
{
	if (listobj){
		listobj.size=1; 
	 	listobj.multiple=false;
	 	listobj.options[1]=new Option("配液正常","N");
	 	listobj.options[2]=new Option("配液取消","C");
	 	listobj.options[3]=new Option("配液拒绝","R");
	 	listobj.options[4]=new Option("医嘱停止","D");
	}
}
function InitPassAudit(listobj)
{
	if (listobj){
		listobj.size=1; 
	 	listobj.multiple=false;
	 	listobj.options[1]=new Option("审核通过","SHTG");
	 	//listobj.options[2]=new Option("正常打包","ZCDB");
	 	//listobj.options[3]=new Option("非正常打包","FZCDB");
	}
}
function FormatNo(no)
{
	var objloc=document.getElementById("tPLocID");
	if (objloc){
		var loc=objloc.value
		if (loc!=""){
			var objm=document.getElementById("mFormatNo");
			if (objm) {var encmeth=objm.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,loc,no);
			return ret;
		}
	}
}
function SetTblRowsColorNew(objtbl,flag)
{
	var lregno="";
	var lmoeori="";
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("selectz"+i);
		if (cell){cell.onclick=selectClick;}
		var cell=document.getElementById("tbSelectz"+i);
		if (cell){cell.onclick=tbSelectClick;}
		var objrow=objtbl.rows[i];
		var regno=""
		var objreg=document.getElementById("tbRegNoz"+i)
		if (objreg) regno=objreg.innerText
		
		var moeori=""
		if (flag==1){
			var objoe=document.getElementById("mOeori"+"z"+i);
			//var objoe=document.getElementById("Tmdodis"+"z"+i);
	    	if (objoe) moeori=objoe.value;
	   	 	var objpaname=document.getElementById("paname"+"z"+i);
	    	var objstdate=document.getElementById("sttdate"+"z"+i);
	    	var objseq=document.getElementById("seqno"+"z"+i);
	    	//var objbed=document.getElementById("bed"+"z"+i);
	    	var objward=document.getElementById("ward"+"z"+i);
		}
		if (flag==2){

			
					
			//var objoe=document.getElementById("tbMOeori"+"z"+i);
			var objoe=document.getElementById("tbMdodis"+"z"+i);
	    	if (objoe) moeori=objoe.value;
	   	 	var objpaname=document.getElementById("tbName"+"z"+i);
	    	var objstdate=document.getElementById("tbOexeDate"+"z"+i);
	    	var objseq=document.getElementById("tbSeqNo"+"z"+i);
	    	//var objbed=document.getElementById("tbBedNo"+"z"+i);
	    	var objward=document.getElementById("tbWard"+"z"+i);
	    	
	    	var objbatno=document.getElementById("tbBatNoz"+i);
	    	var objfreq=document.getElementById("tbFreqz"+i);
	    	var objinst=document.getElementById("tbInstz"+i);
	    	var objdura=document.getElementById("tbDuraz"+i);
		}
	    if (moeori==lmoeori){
			if(objstdate) objstdate.innerText="";
			if(objreg) objreg.innerText="";
		    if(objpaname) objpaname.innerText="";
		    if(objseq) objseq.innerText="";
		    if(objbatno) objbatno.parentNode.innerHTML="";
		    if(objfreq) objfreq.innerText="";
		    if(objinst) objinst.innerText="";
		    if(objdura) objdura.innerText="";
		    //if(objbed) objbed.innerText="";
		    //if(objward) objward.innerText="";
	    }
	    else{
		   	lmoeori=moeori
	    }
	}
}