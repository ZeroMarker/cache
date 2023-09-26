//Add JS To Component(UDHCJFIPReg)
//DHC.WMR.GroupReceipt.Interface.JS

//Add Item To Component(UDHCJFIPReg) for Test
//btnReceipt    Button
//btnUnReceipt     Button

// Add Code To JS(UDHCJFIPReg.js)
// InitReceipt();       				//BodyLoadHandler()
// btnReceipt_onclick();       	//admcancel_click()
// btnUnReceipt_onclick();     	//regsave_click()

function InitReceipt()
{
	var obj=document.getElementById("btnReceipt");
	if (obj){obj.onclick=btnReceipt_onclick;}
	var obj=document.getElementById("btnUnReceipt");
	if (obj){obj.onclick=btnUnReceipt_onclick;}
}

function btnReceipt_onclick()
{
	var CTLocID=session['LOGON.CTLOCID'];
  var UserId=session['LOGON.USERID'];
  var MrNo=document.getElementById("Medicare").value;/////赋值住院登记页面病案号.Medicare为住院登记页面“病案号”Item元素
  //alert(MrNo);
  var AdmType="I"

  var EpisodeID=admidobj.value;
	var flg=GroupReceipt(CTLocID, EpisodeID, MrNo, UserId, AdmType);
	if (flg>=0){
			//alert("接诊成功!");
		}else{
			//add 2010-03-18 接诊错误,再次进行接诊
			flg=GroupReceipt(CTLocID, EpisodeID, MrNo, UserId, AdmType);
			if(flg<0){
				alert("接诊错误,请联系信息科!错误代码:"+flg);
			}
	}
}


function GroupReceipt(CTLocID, EpisodeID, MrNo, UserId, AdmType)
{
	//var strMethod = document.getElementById("MethodGroupReceipt").value;
	//var flg = cspRunServerMethod(strMethod,CTLocID, EpisodeID, MrNo, UserId, AdmType);
	var flg =tkMakeServerCall("web.DHCWMRGroup.DHCWMRGroupReceipt","GroupReceipt",CTLocID, EpisodeID, MrNo, UserId, AdmType);
	return flg;
}

function btnUnReceipt_onclick()
{
  var UserId=session['LOGON.USERID'];
  var EpisodeID=admidobj.value;
	var flg=GroupUnReceipt(EpisodeID,UserId);
	if (flg>=0){
			//alert("取消接诊成功!");
		}else{
			alert("取消接诊错误,请联系信息科!错误代码:"+flg);
	}
}

function GroupUnReceipt(EpisodeID, UserId)
{
	//var strMethod = document.getElementById("MethodGroupUnReceipt").value;
	//var flg = cspRunServerMethod(strMethod, EpisodeID,UserId);
	var flg =tkMakeServerCall("web.DHCWMRGroup.DHCWMRGroupReceipt","GroupUnReceipt",EpisodeID,UserId);
	return flg;
}