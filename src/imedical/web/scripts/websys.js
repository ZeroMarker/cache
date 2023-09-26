var isIECore='';if(!!window.ActiveXObject||"ActiveXObject"in window){isIECore=true;}else{isIECore=false;}
var websys_isIE=false;var msg=new Array();var ieVersion=6.0;if(window.navigator.appName=='Microsoft Internet Explorer'){var userAgent=window.navigator.userAgent;var userAgentArr=userAgent.split(";")
var msieArr=userAgentArr[1].split("MSIE ");if(msieArr.length>1){ieVersion=parseFloat(msieArr[1]);}
websys_isIE=true;};if(!!window.ActiveXObject||"ActiveXObject"in window){websys_isIE=true;}
var websys_topz=201;var websys_url='';var websys_webedit;var websys_isInUpdate=false;var websys_brokerTime=200;function cspRunServerMethod(method){if(method=="")return null;if(cspFindXMLHttp(false)==null){err='Unable to locate XMLHttpObject.';if(typeof cspRunServerMethodError=='function')
return cspRunServerMethodError(err);alert(err);return null;}
return cspIntHttpServerMethod(method,cspRunServerMethod.arguments,false);}
function cspRunServerMethodById(Id){if(Id=="")return nul;var obj=document.getElementById(Id);if(obj){var method=obj.value;return cspRunServerMethod(method);}}
function cspRunServerMethodError(err,errobj){if(err.indexOf("You are logged out")>-1){err="会话已超期，请退出重新登录。\n"+err;}
if(err.indexOf("#864:")>-1){alert("界面长时间未操作，请退出重新登录");return;}
if(arguments.length>1){if(errobj.serverText.indexOf("#864:")>-1){alert("界面长时间未操作，请退出重新登录");return;}}
if(arguments.length>1){if(errobj.serverText){alert(err+" : "+errobj.serverText);return;}}
if(confirm(err+" refresh?")){window.location.href=window.location.href;}}
function websys_putontop(){websys_topz+=1;return websys_topz;}
function websys_lu(url,lookup,posn){if(lookup){if(posn=='')posn='top=100,left=680,width=300,height=380';if(lookup==1){websys_createWindow(url,0,posn+",titlebar=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");}else{websys_createWindow(url,lookup,posn+",titlebar=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");}}else{if(posn=='')posn='width=300,height=380';if(url.indexOf('.DOC')>0)posn='top=0,left=0,width='+screen.availWidth+',height='+screen.availHeight;var n=new Date();var winname='a'+n.getHours()+n.getMinutes()+n.getSeconds()+n.getMilliseconds();websys_createWindow(url,winname,posn+",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");}
return false;}
function websys_locked(){var l=0;for(var i=0;i<document.forms.length;i++){if((document.forms[i].elements['TLOCKED'])&&(document.forms[i].elements['TLOCKED'].value=='1')){l=1;break;}}
return l;}
function websys_help(url,e){if(typeof e!="undefined"){var keycode=websys_getKey(e);}else{var keycode=websys_getKey();}
if(keycode==113){}}
function websys_printme(){if(document.readyState!='complete'){self.setTimeout(websys_printme,1000);}else{self.focus();self.print();}}
function websys_cancelUpArrow(e){var keycode;try{keycode=websys_getKey(e);}catch(ex){keycode=websys_getKey();}
try{if(e.shiftKey&&keycode==54){e.preventDefault?e.preventDefault():(e.returnValue=false);websys_cancel();return false;}}catch(ex){}
return true;};function websys_cancelBackspace(e){var keycode;try{keycode=websys_getKey(e);}catch(ex){keycode=websys_getKey();}
var key=String.fromCharCode(keycode);try{if((websys_getAlt(e)&&keycode==37)){websys_cancel();return false;}
if(keycode==8){var srcEl=websys_getSrcElement(e);var srcElementTag=srcEl.tagName.toUpperCase();var scrElementType="";if(srcElementTag=="INPUT"){scrElementType=srcEl.type.toUpperCase();}
if(srcElementTag=="INPUT"&&scrElementType=="CHECKBOX"){websys_cancel();return false;}
if(srcElementTag=="INPUT"&&scrElementType=="RADIO"){websys_cancel();return false;}
if((srcElementTag!=="INPUT")&&(srcElementTag!=="TEXTAREA")){websys_cancel();return false;}}}catch(e){}
return true;}
function websys_sckey(e){var keycode;try{keycode=websys_getKey(e);}catch(e){keycode=websys_getKey();}
var key=String.fromCharCode(keycode);if(!websys_cancelBackspace(e))return false;if(!websys_cancelUpArrow(e))return false;var key=String.fromCharCode(keycode);key=key.toUpperCase();if(keycode>111&&keycode<123){key="F"+(keycode-111);var menuWin=websys_getMenuWin();if(menuWin.websys_sckeys[key]){menuWin.websys_sckeys[key]();return websys_cancel();}}
if((websys_getAlt(e)&&keycode!=18)||(keycode==33)||(keycode==34)){try{var x=websys_getSrcElement(e);if(x.onchange){x.onchange();for(i in tsc){if(tsc[i]==key){window.setTimeout("websys_setfocus('"+i+"');",websys_brokerTime+1);break;}}}
websys_sckeys[key]();websys_cancel();}
catch(ex){try{var menuWin=websys_getMenuWin();if(menuWin.websys_sckeys[key]){menuWin.websys_sckeys[key]();}}catch(exx){}}}}
function websys_sckeypress(e){if(window.event){var keycode;try{keycode=websys_getKey(e);}catch(e){keycode=websys_getKey();}
var key=String.fromCharCode(keycode);if(key=='^'){window.event.cancelBubble;return false;}}}
var websys_sckeys=new Array();if(websys_isIE==true){document.onkeydown=websys_sckey;document.onkeypress=websys_sckeypress;}
else{document.addEventListener("keydown",websys_sckey)}
function websys_dev(){try{websys_webedit=null;websys_webedit=new self.ActiveXObject("trakWebedit3.trakweb");var params=session['LOGON.USERID']+'^'+session['LOGON.CTLOCID'];websys_webedit.ShowManager(params);websys_webedit=null;}
catch(e){alert(unescape(t['XLAYOUTERR']));}}
function websys_layout(compid,sconn,context){var params=session['LOGON.USERID']+'^'+session['LOGON.CTLOCID']+'^^'+session['LOGON.GROUPID'];if(context=='')context=session['CONTEXT'];try{websys_webedit=null;websys_webedit=new ActiveXObject("trakWebedit3.trakweb");websys_webedit.ShowLayout(params,compid,context,sconn);websys_webedit=null;}catch(e){trakWebEdit3.ShowLayout(params,compid,context,sconn);}}
function websys_getMainWindow(w){if(!w)return null;if((w.top.frames.length)&&(w.top.frames['TRAK_main']))return w.top;else return websys_getMainWindow(w.opener);}
function websys_component(obj,id){var row=document.getElementById(id);if(row){if(row.style.display=='none'){row.style.display='';obj.src="../images/websys/minus.gif";}else{row.style.display='none';obj.src="../images/websys/plus.gif";}}
return websys_cancel();}
function websys_getSrcElement(e){if(window.event)
return window.event.srcElement;else{return e.target;}}
function websys_getParentElement(obj){if(obj.parentElement)
return obj.parentElement;else{return obj.parentNode;}}
function websys_getChildElements(obj){if(document.all)return obj.all;else return obj.getElementsByTagName("*");}
function websys_getType(e){if(window.event)
return window.event.type;else
return e.type;}
function websys_getKey(e){if(e&&e.isLookup)return 117;if(window.event)
return window.event.keyCode;else
return e.which;}
function websys_getButton(e){if((typeof e!="undefined")&&(typeof e.button!="undefined")){return(e.button==0?"L":(e.button==1?"M":(e.button==2?"R":e.button)));}
if(window.event){return(window.event.button==1?"L":(window.event.button==4?"M":(window.event.button==2?"R":window.event.button)));}else{return(e.which==1?"L":(e.which==2?"M":(e.which==0?"R":e.which)));}}
function websys_getAlt(e){if(window.event)
return window.event.altKey;else
return e.altKey;}
function websys_getOffsets(e){if(window.event){var offsets={offsetX:event.offsetX,offsetY:event.offsetY}
return offsets;}else{var target=e.target;if(typeof target.offsetLeft=='undefined'){target=target.parentNode;}
var pageCoords=websys_getPageCoords(target);var offsets={offsetX:window.pageXOffset+e.clientX-pageCoords.x,offsetY:window.pageYOffset+e.clientY-pageCoords.y}
return offsets;}}
function websys_getPageCoords(obj){var coords={x:0,y:0};while(obj){coords.x+=obj.offsetLeft;coords.y+=obj.offsetTop;obj=obj.offsetParent;}
return coords;}
function websys_cancel(){if(window.event)
window.event.cancelBubble=true;return false;}
function websys_returnEvent(){return false;}
function websys_show(id){var mnu=document.getElementById('tbMenu'+id);var itm=document.getElementById('tbMenuItem'+id);mnu.className='tbMenuHighlight';if(itm){itm.className='tbMenuItem';itm.style.left=itm.parentNode.parentNode.offsetLeft;}
return websys_cancel();}
function websys_hide(id){var mnu=document.getElementById('tbMenu'+id);var itm=document.getElementById('tbMenuItem'+id);mnu.className='tbMenu';if(itm){itm.className='tbMenuItemHide';}
return websys_cancel();}
function websys_setTitleBar(title){if(title==""){title="TrakHealth MedTrak";}
top.document.title=title;}
function websys_isDirty(eForm)
{var iNumElems=eForm.elements.length;for(var i=0;i<iNumElems;i++)
{var eElem=eForm.elements[i];if("text"==eElem.type||"TEXTAREA"==eElem.tagName)
{if(eElem.name!='UserCode'){if(eElem.value!=eElem.defaultValue)return true;}}
else if("checkbox"==eElem.type||"radio"==eElem.type)
{if(eElem.checked!=eElem.defaultChecked)return true;}
else if("SELECT"==eElem.tagName)
{var cOpts=eElem.options;var iNumOpts=cOpts.length;for(var j=0;j<iNumOpts;j++)
{var eOpt=cOpts[j];if(eOpt.selected!=eOpt.defaultSelected)return true;}}}
return false;}
function websys_isDirtyPage(eForm)
{var iNumForms=document.forms.length;for(var i=0;i<iNumForms;i++)
{if(websys_isDirty(document.forms[i]))return true;}
return false;}
function websys_isDirtyPagePrompt()
{if((!websys_isInUpdate)&&(websys_isDirtyPage()))window.event.returnValue=t['XUNSAVED'];}
function websys_canfocus(obj){if(((obj.tagName=="INPUT")||(obj.tagName=="A")||(obj.tagName=="TEXTAREA")||(obj.tagName=="SELECT"))&&(obj.type!="hidden")&&(!obj.disabled)&&(!obj.readOnly)){return 1;}
return 0;}
function websys_firstfocus(){for(var i=0,found=0;(i<document.forms.length)&&(!found);i++){var objs=websys_getChildElements(document.forms[i]);for(var j=0;j<objs.length;j++){if(websys_canfocus(objs[j])){websys_setfocus(objs[j].id);found=1;break;}}}}
function websys_nextfocus(index){for(var j=index+1;j<document.all.length;j++){if(websys_canfocus(document.all(j))){websys_setfocus(document.all(j).id);break;}}}
function websys_nextfocusElement(obj){if(obj.sourceIndex){websys_nextfocus(obj.sourceIndex);return};while(1){obj=websys_FindNextSourceElement(obj,1);if(!obj)break;if(websys_canfocus(obj)){websys_setfocus(obj.id);break;}}}
function websys_FindNextSourceElement(obj,checkChild){if(obj==document.body)return null;if((checkChild)&&(obj.childNodes.length)){if(obj.childNodes[0].nodeType==1)return obj.childNodes[0];else return websys_FindNextSourceElement(obj.childNodes[0],0);}else if((obj.nextSibling)){if(obj.nextSibling.nodeType==1)return obj.nextSibling;else return websys_FindNextSourceElement(obj.nextSibling,0);}else if((obj.parentNode.nextSibling)){if(obj.parentNode.nextSibling.nodeType==1)return obj.parentNode.nextSibling;else return websys_FindNextSourceElement(obj.parentNode.nextSibling,0);}else{return websys_FindNextSourceElement(obj.parentNode,0);}}
function websys_nexttab(index,frm){var next='';var nextidx=9999;index=parseInt(index,10);if(frm)var objs=websys_getChildElements(frm);else var objs=document.all;for(var j=0;j<objs.length;j++){if(websys_canfocus(objs[j])){if(objs[j].tabIndex>index&&(objs[j].tabIndex<nextidx)){nextidx=objs[j].tabIndex;next=objs[j].name;if(nextidx==(1+index))break;}}}
if(next!=''){websys_setfocus(next);}}
function websys_firsterrorfocus(){var next='';var nextidx=9999;var index=-1;var objs=websys_getChildElements(document);for(var j=0;j<objs.length;j++){if((objs[j].className=="clsInvalid")&&(websys_canfocus(objs[j]))){if(objs[j].tabIndex>index&&(objs[j].tabIndex<nextidx)){nextidx=objs[j].tabIndex;next=objs[j].name;}}}
if(next!=''){websys_setfocus(next);}}
function websys_setfocus(objName){setTimeout('websys_setfocus2(\''+objName+'\')',50);}
function websys_setfocus2(objName){var obj=document.getElementById(objName);if(obj){try{obj.focus();obj.select();}catch(e){}}}
function websys_escape(str){if(str.indexOf("%")>-1){str=str.split("%").join("%25");}
while(str.indexOf("?")>-1){str=str.replace("?","%3F");}
while(str.indexOf("=")>-1){str=str.replace("=","%3D");}
while(str.indexOf(" ")>-1){str=str.replace(" ","%20");}
while(str.indexOf("\"")>-1){str=str.replace("\"","%22");}
while(str.indexOf("&")>-1){str=str.replace("&","%26");}
while(str.indexOf("#")>-1){str=str.replace("#","%23");}
while(str.indexOf(String.fromCharCode(13,10))>-1){str=str.replace(String.fromCharCode(13,10),"%0D%0A");}
if(str.indexOf("+")>-1){str=str.split("+").join("%2B");}
while(str.indexOf(String.fromCharCode(1))>-1){str=str.replace(String.fromCharCode(1),"%01");}
while(str.indexOf(String.fromCharCode(2))>-1){str=str.replace(String.fromCharCode(2),"%02");}
return str;}
function websys_reSize(){var h=0;var w=0;var f=websys_getChildElements(this.document.body);for(var i=0;i<f.length;i++){if(f[i].tagName=="DIV"){if(f[i].offsetHeight>h)h=f[i].offsetHeight;if(f[i].offsetWidth>w)w=f[i].offsetWidth;}}
if(h>eval(window.screen.Height-window.screenTop))h=eval(window.screen.Height-window.screenTop)-40;if(w>eval(window.screen.Width-window.screenLeft))w=eval(window.screen.Width-window.screenLeft)-40;this.resizeTo(w+30,h+45);window.focus();}
function websys_reSizeT(e){var w=0;var h=0;var f=websys_getChildElements(this.document.body);for(var i=0;i<f.length;i++){if(f[i].tagName=="TABLE"){if(f[i].offsetWidth>w)w=f[i].offsetWidth;}}
if(w>eval(window.screen.Width-window.screenLeft))w=eval(window.screen.Width-window.screenLeft)-40;if(w<282)w=282;if(h>eval(window.screen.Height-window.screenTop))h=eval(window.screen.Height-window.screenTop)-40;h=document.body.offsetHeight;if(h<380)h=380;this.resizeTo(w+30,h);this.resizeBy(0,27);}
function websys_move(left,top,width,height){if((window.top.frames["eprmenu"])||(window.top.frames["TRAK_menu"])||(window.top.frames["TRAK_main"])){return;}
var xwin=null;if(window.opener){xwin=window;}else{xwin=window.top;}
if(left<0)left=0;if(top<0)top=0;if(width<200)width=200;if(height<200)height=200;xwin.moveTo(left,top);xwin.resizeTo(width,height);}
function websys_getPositionX(e){if(window.event){return window.event.x;}else{return e.clientX;}}
function websys_getPositionY(e){if(window.event){return window.event.y;}else{return e.clientY;}}
var websys_windows=new Array();function websys_createWindow(url,wname,features){var oldFeatures=features;if(typeof features!='undefined'){features=features.toUpperCase();if(features.indexOf('STATUS=')==-1){features="status,"+features;oldFeatures="status,"+oldFeatures;}
if(features.indexOf('SCROLLBARS=')==-1){features="scrollbars,"+features;oldFeatures="scrollbars,"+oldFeatures;}
if(features.indexOf('RESIZABLE=')==-1){features="resizable,"+features;oldFeatures="resizable,"+oldFeatures;}}
var openobj=window;if(ieVersion>6){if(typeof(window.dialogArguments)=="object"){if((window.dialogArguments)&&(window.dialogArguments.hasOwnProperty('window'))){openobj=window.dialogArguments.window;openobj.dialogWindow=window;}}}
oldFeatures=oldFeatures||"";features=features||"";features=features.toLowerCase();var obj={};var arr=oldFeatures.split(",");for(var ind=0;ind<arr.length;ind++){var item=arr[ind];if(item!=""){var itemArr=item.split("=");if(itemArr.length==1){obj[itemArr[0]]="yes";}else{if(itemArr[1].toLowerCase()=="true"||itemArr[1].toLowerCase()=="false"){obj[itemArr[0]]=itemArr[1].toLowerCase()=="true"?true:false;}else{obj[itemArr[0]]=itemArr[1]||"";}}}}
if(features.indexOf('hisui=true')>-1&&'undefined'!=typeof websys_showModal){if(obj["iconcls"]){obj.iconCls=obj["iconcls"];}else{obj.iconCls="icon-w-paper";}
if(websys_showModal)websys_showModal($.extend(obj,{url:url}));}else if(features.indexOf("addtab=1")>-1&&'undefined'!=typeof websys_addTab){if(websys_addTab)websys_addTab($.extend(obj,{url:url}));}else{obj=calcPosition(obj,window);if(obj.top){obj.top-=30;}
if(obj.left){obj.left-=10;}
features="";for(var pind in obj){if(features=="")features=pind+"="+obj[pind];else features+=","+pind+"="+obj[pind];}
websys_windows[wname]=openobj.open(url,wname,features);}
return websys_windows[wname];}
function websys_closeWindows(){for(w in websys_windows){try{if(!websys_windows[w].closed){websys_windows[w].isclosing=1;websys_windows[w].close();}}catch(e){}}}
function websys_onunload(){websys_closeWindows();}
window.onunload=websys_onunload;function websys_print(printoptions,url,params,target,javascript){var tablename="";try{var eSrc=websys_getSrcElement();if(eSrc)var tbl=getTableName(eSrc);if(tbl)tablename=tbl.id;}catch(e){}
if(printoptions==1){var CONTEXT="";var objCONTEXT=document.getElementById('CONTEXT');if(objCONTEXT){CONTEXT=objCONTEXT.value;}
url=escape(url);var turl="websys.default.csp?WEBSYS.TCOMPONENT=websys.PrintOptions.Edit&printoptions="+printoptions+"&url="+url+"&params="+params+"&CONTEXT="+CONTEXT;turl+="&target="+target+"&javascript="+javascript+"&tablename="+tablename;websys_createWindow(turl,1,"width=260,height=180,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");}else{var jobdone=0;if(javascript!=""){if(tablename!=""){javascript=javascript+"('"+tablename+"','"+url+"','"+target+"')"}else{javascript=javascript+"('"+url+"','"+target+"')"}
try{jobdone=1;eval(javascript);}catch(e){}
if((jobdone==0)&&(window.opener)){javascript="window.opener."+javascript;eval(javascript);}}else{websys_createWindow(url,target);}}}
function websys_$(element){if(arguments.length>1){for(var i=0,elements=[],length=arguments.length;i<length;i++)
elements.push($(arguments[i]));return elements;}
if(typeof element=="string")
return document.getElementById(element);}
function websys_$V(element){return websys_$(element).value;}
function $V(element){return websys_$(element).value;}
function addHand(h,k,r)
{if(h.addEventListener){if(k.indexOf("on")!=-1){k=k.substr(2);}
h.addEventListener(k,r,false)}else if(h.attachEvent){h.attachEvent(k,r)}else{var M=h[k];h[k]=function(){var x=M.apply(this,arguments),t=r.apply(this,arguments);return x==undefined?t:(t==undefined?x:t&&x)}}}
var resizeListContainer=function(){var listDiv=document.getElementsByClassName("i-tbListContainer")
if(listDiv&&listDiv.length&&listDiv.length>0){listDiv[0].style.height=500;listDiv[0].style.width=1000;}}
var quickK={f7:function(){window.location.href=window.location.href;},f8:'',f9:'',addMethod:function()
{if(typeof this.f7=='function')
addHand(document.body,'onkeydown',function(){if(event.keyCode==118)quickK.f7();});if(typeof this.f8=='function')
addHand(document.body,'onkeydown',function(){if(event.keyCode==119)quickK.f8();});if(typeof this.f9=='function')
addHand(document.body,'onkeydown',function(){if(event.keyCode==120)quickK.f9();});}};String.prototype.toDate=function()
{var dd=this.split(/\D/);if(dd.length==1){dd[0]=this.substring(0,4);dd[1]=this.substring(4,6);dd[2]=this.substring(6,8);}
if(dd.length!=3)return"";if(dd[1].length==1)dd[1]="0"+dd[1];if(dd[2].length==1)dd[2]="0"+dd[2];var str=dd.join('-');if(!str.match(/^\d{4}\-\d\d?\-\d\d?$/)){return"";}
var ar=str.replace(/\-0/g,"-").split("-");ar=new Array(parseInt(ar[0]),parseInt(ar[1])-1,parseInt(ar[2]));var d=new Date(ar[0],ar[1],ar[2]);if(d.getFullYear()==ar[0]&&d.getMonth()==ar[1]&&d.getDate()==ar[2])
return str;return"";}
function dhcsys_getsidemenuform(){var frm=null;try{var win=window;if(win){frm=win.document.forms['fEPRMENU'];if(frm)return win;}
win=top.frames['TRAK_menu'];if(win){frm=win.document.forms['fEPRMENU'];if(frm)return frm;}
win=opener;if(win){frm=win.document.forms['fEPRMENU'];if(frm)return frm;}
win=parent.frames[0];if(win){frm=win.document.forms["fEPRMENU"];if(frm)return frm;}
if(top){frm=top.document.forms["fEPRMENU"];if(frm)return frm}}catch(e){}
return frm;}
function websys_getMenuWin(){var win=null;try{var win=window;if(win){frm=win.document.forms['fEPRMENU'];if(frm)return win;}
win=top.frames['eprmenu'];if(win){frm=win.document.forms['fEPRMENU'];if(frm)return win;}
win=parent.frames[0];if(win){frm=win.document.forms["fEPRMENU"];if(frm)return win;}
if(top){frm=top.document.forms["fEPRMENU"];if(frm)return top;}
win=opener;if(win){frm=win.document.forms['fEPRMENU'];if(frm)return win;}
win=top.opener;if(win){frm=win.document.forms['fEPRMENU'];if(frm)return win;}
win=top.opener;if(win){frm=win.top.document.forms['fEPRMENU'];if(frm)return win.top;}
win=top.opener.opener;if(win){frm=win.top.document.forms['fEPRMENU'];if(frm)return win.top;}}catch(e){}
return win;}
function dhcsys_getmenuform(){var frm=null;try{var win=websys_getMenuWin();if(win){return win.document.forms['fEPRMENU'];}else{return window.fEPRMENU;}}catch(e){return window.fEPRMENU;}
return frm;}
function dhcsys_calogon(locDesc,userName){var ret={};userName=userName||"";var flag=tkMakeServerCall("websys.CAInterface","IsCaLogon",locDesc,userName);if(flag==1){var strContainerName="";var ContainerNameStr=dhcsys_getContainerNameAndPin();if(ContainerNameStr.indexOf("^")>-1)strContainerName=ContainerNameStr.split("^")[0];if(strContainerName==""){strContainerName=window.showModalDialog("../csp/dhc.logon.ca.csp",{window:window},"dialogWidth:300px;dialogHeight:250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");strContainerName=strContainerName.split('^')[0];}
if((strContainerName=="")||(strContainerName=="undefined")||(strContainerName==null)){return{IsSucc:false,ContainerName:""};}else{ret={ContainerName:strContainerName,IsSucc:true};}}else{ret={IsSucc:true,ContainerName:""};}
return ret;}
function dhcsys_getcacert(cfg){var SignUserCode="";if(typeof cfg=='object'){SignUserCode=cfg.SignUserCode;}
var obj={},varCert="",ContainerName="",CTLoc="";var failRtn={IsSucc:false,varCert:"",ContainerName:""};if(session['LOGON.CTLOCID']){CTLoc=session['LOGON.CTLOCID'];}
if(CTLoc=="")return{IsSucc:true,varCert:"",ContainerName:""};;var ContainerName=dhcsys_getContainerNameAndPin();if(ContainerName.indexOf("^")>-1)ContainerName=ContainerName.split("^")[0];var userName=session['LOGON.USERCODE'];var flag=tkMakeServerCall("websys.SessionLogon","IsCaLogon",CTLoc,userName);if(flag!=1){return{IsSucc:true,varCert:"",ContainerName:""};}
if(ContainerName){var userList=GetUserList();var causerArr=userList.split("&&&");for(var i=0;i<causerArr.length;i++){if(causerArr[i].split("||").length>1&&causerArr[i].split("||")[1]==ContainerName){return{IsSucc:true,varCert:GetSignCert(ContainerName),ContainerName:ContainerName};}}}
var param="?a=1";if(SignUserCode!="")param+="&SignUserCode="+SignUserCode
obj.ContainerName=window.showModalDialog("../csp/dhc.logon.ca.csp"+param,{window:window},"dialogWidth:300px;dialogHeight:250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;")||"";obj.ContainerName=obj.ContainerName.split('^')[0];obj.IsSucc=true;if(obj.IsSucc&&obj.ContainerName){return{IsSucc:true,varCert:GetSignCert(obj.ContainerName),ContainerName:obj.ContainerName};}
return failRtn;}
function dhcsys_alert(msg,dialogWidth,dialogHeight,fontSize){if(websys_isIE){var width=dialogWidth||300;var height=dialogHeight||120;dhcsys_createMask();window.showModalDialog("../csp/alert.html",{msg:msg,fontSize:fontSize},"dialogWidth:"+parseFloat(width)+"px;dialogHeight:"+parseFloat(height)+"px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");dhcsys_closeMask();}else{alert(msg);}}
function dhcsys_confirm(msg,YesOrNo,fontSize,btnValue,dialogWidth,dialogHeight){if(window.showModalDialog){if(arguments.length==1){YesOrNo="YES";}
dialogWidth=dialogWidth||300;dialogHeight=dialogHeight||120;dhcsys_createMask();var rtn=window.showModalDialog("../csp/confirm.html",{msg:msg,YesOrNo:YesOrNo,fontSize:fontSize,btnValue:btnValue,width:dialogWidth,height:dialogHeight},"dialogWidth="+dialogWidth+"px;dialogHeight="+dialogHeight+"px;center=yes;toolbar=no;menubar=no;resizable=no;location=no;status=no;help=no;");dhcsys_closeMask();return rtn;}else{return window.confirm(msg);}}
function websys_EventLog(modelname,condition,content,secretCode){var rtn=tkMakeServerCall("web.DHCEventLog","EventLog",modelname,condition,content,secretCode);return rtn;}
function rewriteUrl(url,obj){var reg,flag,indexFlag=false;var indexFlag=(url.indexOf("?")==-1);if(indexFlag){url+="?";}
for(var i in obj){if(obj.hasOwnProperty(i)){flag=false;if(!indexFlag){reg=new RegExp(i+"=(.*?)(?=$|&)","g");url=url.replace(reg,function(m1){flag=true;return i+"="+obj[i];});}
if(!flag){url+="&"+i+"="+obj[i];}}}
return url;}
function websys_rewriteUrl(url,obj){rewriteUrl(url,obj);}
function websys_getTextContent(obj){if(websys_isIE)
return obj.innerText;else{return obj.textContent;}}
function removeClass(obj,itmCls){if(obj.className){var classArr=obj.className.split(" ");for(var i=0;i<classArr.length;i++){if(classArr[i]==itmCls){classArr.splice(i,1)}}
obj.className=classArr.join(" ")}
return obj;}
function addClass(obj,itmCls){if(obj&&obj.className){var classArr=obj.className.split(" ");for(var i=0;i<classArr.length;i++){if(classArr[i]==itmCls){return obj}}
classArr.push(itmCls)
obj.className=classArr.join(" ");}else{obj.className=itmCls;}
return obj;}
function websys_removeClass(obj,itmCls){removeClass(obj,itmCls)}
function websys_addClass(obj,itmCls){addClass(obj,itmCls)}
function emptyFun(event){return false;}
function websys_disable(obj){if(arguments.length>0){if(typeof obj=="string"){obj=document.getElementById(obj);}}else{return;}
if(obj.tagName=="A"){obj.onclick=emptyFun;}
obj.setAttribute('disabled','disabled');addClass(obj,"i-disabled");}
function websys_enable(obj,fun){if(arguments.length>0){if(typeof obj=="string"){obj=document.getElementById(obj);}}else{return;}
obj.removeAttribute('disabled');if(obj.tagName=="A"){if(arguments.length>1)obj.onclick=fun;}
removeClass(obj,"i-disabled");}
function exec(command)
{if(websys_isIE){window.oldOnError=window.onerror;window._command=command;window.onerror=function(err){if(err.indexOf('utomation')>-1){alert('命令'+window._command+'已经被用户禁止！');return true;}else{return false;}};var wsh=new ActiveXObject('WScript.Shell');if(wsh){wsh.Run(command);}
window.onerror=window.oldOnError;}else{if(CmdShell){CmdShell.clear();CmdShell.notReturn=1;CmdShell.Run(command);}}}
function websys_exec(command){exec(command);}
function getOffsetTop(o){var top=0;var offsetParent=o;while(offsetParent!=null&&offsetParent!=document.body)
{top+=parseInt(offsetParent.offsetTop)
offsetParent=offsetParent.offsetParent;}
return top;}
function resizeWidth(){var tblListFlexHeader=document.getElementByClass("tblListFlexHeader");tblListFlexHeader}
function GetServerIP(){return tkMakeServerCall("ext.util.String","ServerIP");}
function dhcsys_getComputerName()
{var regedit=new RegEdit();var computerName=regedit.regRead("HKEY_CURRENT_USER\\Volatile Environment\\ViewClient_Machine_Name");if((computerName!="")&&(computerName!=null))return computerName;var computerName;try
{var WshNetwork=new ActiveXObject("WScript.Network");computerName=WshNetwork.ComputerName;WshNetwork=null;}catch(e){computerName="";}
return computerName;}
function RegEdit(){this.shell=new ActiveXObject("WScript.Shell");this.regRead=regRead;this.regWrite=regWrite;this.regDelete=regDelete;}
function regRead(strName){var val=null;try{val=this.shell.regRead(strName);}catch(e){}
return val;}
function regWrite(strName,anyValue,strType){if(strType==null)
strType="REG_SZ";this.shell.regWrite(strName,anyValue,strType);}
function regDelete(strName){this.shell.regDelete(strName);}
function websys_printout(xmlName,params){var href="dhctt.xmlprint.csp?xmlName="+xmlName+"&"+params;websys_createWindow(href,"TRAK_hidden","width=330,height=160,top=1200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");return;}
function websys_printview(xmlName,params,opt){if(typeof opt=="undefined"){opt="width=630,height=560,top=100,left=100,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes";}
var href="dhctt.xmlpreview.csp?xmlName="+xmlName+"&"+params
websys_createWindow(href,"preview",opt+",toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");return;}
function dhcsys_getFrameObjByName(parentFraObj,fraName){var ObjList=[];if(typeof parentFraObj.frames=="undefined"){return null}
function getFrameObjByName(parentObj){if(parentObj.name==fraName){ObjList.push(parentObj);}
for(var i=0;i<parentObj.frames.length;i++){getFrameObjByName(parentObj.frames[i]);}}
getFrameObjByName(parentFraObj);if(ObjList.length>0)return ObjList[0]
return null}
var websys_SetValByCol=function(colname,inname){if(inname=="")return;var inputObj=document.getElementById(inname);if(!inputObj)return;if(colname==""){if(inputObj.type.toUpperCase()=="CHECKBOX"){inputObj.checked=false;}else{inputObj.value="";}
return;}
var obj=document.getElementById(colname);var val;if(obj){if(obj.tagName=="LABEL"){val=obj.innerText;}
if(obj.tagName=="INPUT"){val=obj.value;}
if(inputObj.type.toUpperCase()=="CHECKBOX"){if(val=="Y"||val=="是"){inputObj.checked=true;}else{inputObj.checked=false;}}else{inputObj.value=val;}}}
var websys_getVal=function(inname){if(inname=="")return"";var inputObj=document.getElementById(inname);if(!inputObj)return;if(inputObj.type.toUpperCase()=="CHECKBOX"){if(inputObj.checked){return"Y";}else{return"N";}}
if(inputObj.tagName=="LABEL"){val=inputObj.innerText;}
if(inputObj.tagName=="INPUT"){val=inputObj.value;}
if(inputObj.tagName=="SELECT"){var index=inputObj.selectedIndex;val=myselect.options[index].value;}
return val;}
function websys_trim(str){return str.replace(/(^\s*)|(\s*$)/g,'');}
function websys_trimLeft(str){return str.replace(/(^\s*)/g,"");}
function websys_trimRight(str){return str.replace(/(\s*$)/g,"");}
function GetLocalIPAddr(){var oSetting=null;var ip=null;try{oSetting=new ActiveXObject("rcbdyctl.Setting");ip=oSetting.GetIPAddress;if(ip.length==0){return"没有连接到Internet";}oSetting=null;}catch(e){return ip;}return ip;}
function calcPosition(opt,win){var outerHeight=0;var outerWidth=0;try{outerHeight=top.document.documentElement["clientHeight"];outerWidth=top.document.documentElement["clientWidth"];}catch(e){win=window;}
if(win){outerHeight=window.screen.availHeight;outerWidth=window.screen.availWidth;}
if(outerHeight==0)outerHeight=top.document.documentElement["offsetHeight"];if(outerWidth==0)outerWidth=top.document.documentElement["offsetWidth"];if("undefined"==typeof opt.width){opt.width="80%";}
if("undefined"==typeof opt.height){opt.height="80%";}
if("undefined"==typeof opt.top){opt.top="";}
if("undefined"==typeof opt.left){opt.left="";}
if("string"==typeof opt.top&&opt.top!=""){if(opt.top.indexOf("%")>-1){opt.top=parseFloat(opt.top)*0.01*outerHeight;}
opt.top=parseInt(opt.top);}
if("string"==typeof opt.left&&opt.left!=""){if(opt.left.indexOf("%")>-1){opt.left=parseFloat(opt.left)*0.01*outerWidth;}
opt.left=parseInt(opt.left);}
if("string"==typeof opt.width){if(opt.width.indexOf("%")>-1){opt.width=parseFloat(opt.width)*0.01*outerWidth;}
opt.width=parseInt(opt.width);}
if("string"==typeof opt.height){if(opt.height.indexOf("%")>-1){opt.height=parseFloat(opt.height)*0.01*outerHeight;}
opt.height=parseInt(opt.height);}
if(opt.left==''){opt.left=(outerWidth-opt.width)/2;}
if(opt.top==''){opt.top=(outerHeight-opt.height)/2;}
if(opt.left<0){opt.left=0;}
if(opt.top<0){opt.top=0;}
return opt;}
function websys_showModal(opt){var his7plus=true;try{if(top&&top.frames['eprmenu']){his7plus=false;}}catch(e){his7plus=false;}
if(typeof opt=='string'){var windowJObj="";var win=window;try{if(top.websys_showModal){win=top;}else{if(window.$){var countWin=win.$('div[data-type="websysmodel"]').length;if(countWin>0){win=window;}else if(parent.window.$){countWin=parent.window.$('div[data-type="websysmodel"]').length;if(countWin>0){win=parent.window;}}}}}catch(e){}
if(!his7plus){win=window;}
if(win.$){var countWin=win.$('div[data-type="websysmodel"]').length;var windowJObj=win.$("#WinModalEasyUI"+(countWin-1));}
if(windowJObj&&windowJObj.length>0){if(opt=='hide'){windowJObj.window("minimize");return;}
if(opt=='minimize'){windowJObj.window("minimize");return;}
if(opt=='close'){windowJObj.window("close");return;}
if(opt=='options'){return windowJObj.window("options");}}
return;}
if(his7plus&&top!=window&&top.websys_showModal){top.websys_showModal(opt);}else{var winJObj="",countWin=$('div[data-type="websysmodel"]').length
var defOpt={frameId:"modalfrm"+countWin,modal:true,isTopZindex:false,resizable:true,closable:true,width:"80%",height:"80%",top:'',left:'',collapsible:false,minimizable:false,maximizable:false,title:"对话框",showbefore:null,showafter:null,content:"无内容",onClose:function(){$(this).window("destroy")}};opt=$.extend({},defOpt,opt);if(opt.url){opt.content='<iframe id="'+opt.frameId+'" src="'+opt.url+'" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>';}
if(!$.browser){$.browser={};$.browser.mozilla=/firefox/.test(navigator.userAgent.toLowerCase());$.browser.webkit=/webkit/.test(navigator.userAgent.toLowerCase());$.browser.opera=/opera/.test(navigator.userAgent.toLowerCase());$.browser.msie=/msie/.test(navigator.userAgent.toLowerCase());}
opt=calcPosition(opt);if(winJObj=="")winJObj=$('<div id="WinModalEasyUI'+countWin+'"  style="padding:0px;overflow:hidden;"  data-type="websysmodel"></div>').appendTo("body");winJObj.window(opt).window("open").window("move",{top:opt.top,left:opt.left});}}
function websys_addTab(opt){var his7plus=true;if(top&&top.frames['eprmenu']){his7plus=false;}
if(top!=window&&top.websys_addTab&&his7plus){top.websys_addTab(opt);}
var mwin=window.frames["TRAK_main"];if(mwin){if(mwin&&mwin.addTab){mwin.addTab(opt);}else{mwin.location="websys.hisui.csp?MutilTabMenu=1"}}}
function toUTF8Array(str){var arr=str.split('');var newArr=[];for(var i=0;i<arr.length;i++){var item=arr[i];var utf8Item=encodeURI(item);if(item==utf8Item){newArr.push(item.charCodeAt(0));}else{var tmpArr=utf8Item.split("%");for(var j=1;j<tmpArr.length;j++){newArr.push(parseInt(tmpArr[j],16));}}}
return newArr;}
function simpleEncrypt(src,key){key=key||"IMedical";var rtn=[];var srcList=toUTF8Array(src);var len=srcList.length;var ReKeyLen=len/key.length;var okey="";while(ReKeyLen-->0){okey+=key;}
var c='',c16=0;for(var i=0;i<len;i++){c=srcList[i]^okey.charAt(i).charCodeAt(0);c16=c.toString(16).toUpperCase();if(c<=15){c16="0"+c16;}
rtn.push(c16);}
return rtn.join('');}
function dhcsys_createMask(opt){var defopt={fontSize:"16px",msg:"load...",top:"20%",left:"45%",opacity:40,isLoad:true};opt=opt||defopt;opt.opacity=opt.opacity||40;opt.fontSize=opt.fontSize||"16px";opt.msg=opt.msg||"load...";opt.top=opt.top||"30%";opt.left=opt.left||"45%"
var divObj=document.createElement("DIV");divObj.id="_auto_dhcsys_mask"
divObj.style.backgroundColor="#000000";divObj.style.opacity=opt.opacity/100;divObj.style.filter="alpha(opacity="+opt.opacity+")";divObj.style.left=0;divObj.style.top=0;divObj.style.width="100%";divObj.style.height="100%";divObj.style.display='block';divObj.style.position="absolute";divObj.style.zIndex=1000;document.body.appendChild(divObj);var html='<h1 style="top:'+opt.top+';left:'+opt.left+';position:absolute">';if(opt.isLoad)html+='<image src="../skin/default/images/loading.gif"/>';html+='<font color="#ffffff" size="'+opt.fontSize+'">'+opt.msg+'</font></h1><iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;top:0px;left:0px;width:100%;height:100%;"/>';divObj.innerHTML=html
return divObj;}
function dhcsys_closeMask(){var divObj=document.getElementById("_auto_dhcsys_mask");document.body.removeChild(divObj);}
function isAccessMP(PLineCode,ModelCode){var flag=tkMakeServerCall("BSP.Lic.SRV.Interface","IsAccessByMP",PLineCode,ModelCode);return flag;}
function getClientIP(){if(CmdShell&&CmdShell.GetConfig){var rtnObj=CmdShell.GetConfig();if("string"==typeof rtnObj)eval("rtnObj = "+rtnObj);var rtn=rtnObj.rtn;eval("var obj = "+rtn);return unescape(obj.IP)+"^"+unescape(obj.HostName)+"^"+unescape(obj.Mac);}
return"";}
var parseJsonByPara=function(expStr,key){var json={};var arr=expStr.split("&");var itemArr="";for(var i=0;i<arr.length;i++){itemArr=arr[i].split("=");json[itemArr[0]]=itemArr[1];};if(arguments.length>1){return json[key];}
return json;}
var websys_ReadExcel=function(excelName,async){async=async||0;var strArr=[];strArr.push('Function vbs_Test');strArr.push('Set xlApp = CreateObject("Excel.Application")');if(excelName==""){;strArr.push('fName=xlApp.GetSaveAsFilename ("","Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls",,"请选择需要导入的文件")');strArr.push("If fName=False Then");strArr.push(" xlApp.Quit");strArr.push(" Set xlApp=Nothing");strArr.push(" vbs_Test=0");strArr.push(" Exit Function");strArr.push("End If");strArr.push('Set xlBook = xlApp.Workbooks.Open(fName)');}else{;strArr.push('Set xlBook = xlApp.Workbooks.Open("'+excelName+'")');};strArr.push('Set xlSheet = xlBook.ActiveSheet');strArr.push('rc=xlSheet.UsedRange.Rows.Count');strArr.push('cc=xlSheet.UsedRange.Columns.Count');strArr.push('arr = xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(rc,cc)).Value2');strArr.push('rtn = "["');strArr.push('For ri = 1 To rc');strArr.push(' rowstr = "["');strArr.push(' For ci = 1 To cc');strArr.push('  colstr="""" & Replace(arr(ri,ci),"""","\\""") & """"');strArr.push('    If rowstr <> "[" Then');strArr.push('        rowstr = rowstr & ","');strArr.push('     End If');strArr.push('       rowstr = rowstr & colstr');strArr.push(' Next');strArr.push(' rowstr = rowstr & "]"');strArr.push(' If rtn = "[" Then');strArr.push('    rtn = rtn & rowstr');strArr.push(' Else');strArr.push('    rtn = rtn & "," & rowstr');strArr.push(' End If');strArr.push('Next');strArr.push('rtn = rtn & "]"');strArr.push('xlBook.Close(False)');strArr.push('xlApp.Quit');strArr.push('Set xlSheet= Nothing');strArr.push('Set xlBook= Nothing');strArr.push('Set xlApp=Nothing');strArr.push('vbs_Test=rtn');strArr.push('End Function\n');var rtn="";var exec=strArr.join("\n");var o;if(isIECore){var IECmdShell=new ActiveXObject("MSScriptControl.ScriptControl");IECmdShell.Language='VBScript';IECmdShell.Timeout=10*60*1000;IECmdShell.AddCode(exec);try{rtn=IECmdShell.Run("vbs_Test");eval("var o=("+rtn+")");}catch(e){o=[];alert(e.message);}}else{CmdShell.notReturn=async;rtn=CmdShell.EvalJs(exec,"VBScript");if(rtn.status==200){eval("var o=("+rtn.rtn+")");}else{o=[];alert(rtn.msg);}};return o||[];}
function dhcsys_calogon(locDesc,userName,logonType,singleLogon){var ret={};var flag=IsCaLogon(locDesc,userName);if(flag==1){var strContainerName="";var ContainerNameStr=dhcsys_getContainerNameAndPin();if(ContainerNameStr.indexOf("^")>-1)strContainerName=ContainerNameStr.split("^")[0];if(strContainerName==""){ret=dhcsys_showcaLogon(logonType,singleLogon,0,locDesc);if("undefined"==typeof ret){return{"IsSucc":false,"IsCA":true,"ContainerName":""}};if("string"==typeof ret){var arr=ret.split('^');strContainerName=arr[0];ret={"IsCA":true,ContainerName:strContainerName,varCert:""};}else if("object"==typeof ret){ret.IsCAReLogon=true;strContainerName=ret.ContainerName}}
if((strContainerName=="")||(strContainerName=="undefined")||(strContainerName==null)){return{IsSucc:false,ContainerName:""};}else{ret.IsSucc=true;ret.ContainerName=strContainerName;}}else{ret={IsSucc:true,ContainerName:""};}
return ret;}
function dhcsys_getContainerNameAndPin(){return tkMakeServerCall("websys.CAInterface","GetContainerNameAndPin");}
function IsCaLogon(locDesc,userName){return tkMakeServerCall("websys.CAInterface","IsCaLogon",locDesc,userName);}
function dhcsys_showcaLogon(logonType,singleLogon,autoSure,locDesc){dhcsys_createMask()
if("undefined"===typeof singleLogon)singleLogon=1;if("undefined"===typeof logonType)logonType="UKEY";if("undefined"===typeof autoSure)autoSure="0";if("undefined"===typeof locDesc)locDesc="";var ret=window.showModalDialog("dhc.logon.ca.csp?locDesc="+locDesc+"&singleLogon="+singleLogon+"&logonType="+logonType+"&autoSure="+autoSure,{window:window},"dialogWidth:400px;dialogHeight:400px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");dhcsys_closeMask();return ret;}
function dhcsys_calogonshow(locDesc,userName,logonType,singleLogon){var ret={},strContainerName="";var flag=IsCaLogon(locDesc,userName);if(flag==1){if("undefined"===typeof singleLogon)singleLogon=1;if("undefined"===typeof logonType)logonType="UKEY";var ret=dhcsys_showcaLogon(logonType,singleLogon,0,locDesc);if("undefined"==typeof ret){return{"IsSucc":false,"IsCA":true,"ContainerName":""}};if("string"==typeof ret){var arr=ret.split('^');strContainerName=arr[0];ret={"IsCA":true,ContainerName:strContainerName,varCert:""};}else if("object"==typeof ret){strContainerName=ret.ContainerName}
if((strContainerName=="")||(strContainerName=="undefined")||(strContainerName==null)){return{IsSucc:false,"IsCA":true,ContainerName:""};}else{ret.IsSucc=true;}}else{ret={IsSucc:true,"IsCA":false,ContainerName:"",varCert:""};}
return ret;}
function dhcsys_getcacert(callback,logonType,singleLogon,forceOpen){var win=websys_getMenuWin();if(win!=self&&win.dhcsys_getcacert){return win.dhcsys_getcacert(callback,logonType,singleLogon,forceOpen);}
if("undefined"===typeof singleLogon)singleLogon=1;if("undefined"===typeof logonType){logonType="UKEY";if("undefined"!=typeof LastCALogonType)logonType=LastCALogonType;}
if("undefined"===typeof forceOpen)forceOpen=0;var obj={},varCert="",ContainerName="",CTLoc="",arr=[],rtn={};var failRtn={IsSucc:false,varCert:"",ContainerName:"","IsCA":false};if(session['LOGON.CTLOCID']){CTLoc=session['LOGON.CTLOCID'];}
if(CTLoc==""){rtn={IsSucc:true,varCert:"",ContainerName:"","IsCA":false};if(callback)callback(rtn);return rtn;}
var userName=session['LOGON.USERCODE'];if(!forceOpen){var flag=IsCaLogon(CTLoc,userName);if(flag==0){rtn={IsSucc:true,varCert:"",ContainerName:"","IsCA":false};if(callback)callback(rtn);return rtn;}
ContainerName=dhcsys_getContainerNameAndPin();if(ContainerName.indexOf("^")>-1){arr=ContainerName.split("^");ContainerName=arr[0];}}
if(ContainerName){var rtn={"IsCA":true,IsSucc:true,ContainerName:ContainerName,UserName:arr[7]||"",UserID:arr[6]||"",CALogonType:arr[2]||"",CAUserCertCode:arr[3]||"",CACertNo:arr[4]||"",CAToken:arr[5]||"",ca_key:ca_key||""};if(logonType=="PHONE"){rtn.varCert=GetSignCert(ContainerName);if(callback)callback(rtn);return rtn;}
if(logonType=="UKEY"){var userList=GetUserList();var causerArr=userList.split("&&&");for(var i=0;i<causerArr.length;i++){if(causerArr[i].split("||").length>1&&causerArr[i].split("||")[1]==ContainerName){rtn.varCert=GetSignCert(ContainerName);if(callback)callback(rtn);return rtn;}}}}
obj=dhcsys_calogonshow(CTLoc,userName,logonType,singleLogon);if((arr.length==0&&obj.CALogonType!=LastCALogonType)||((arr.length>2)&&(obj.CALogonType!=LastCALogonType))){if(obj.CAJsPath){var head=document.head||document.getElementsByTagName("head")[0]||document.documentElement;var oscript=document.createElement("script");oscript.type="text/javascript";oscript.charset="gb2312";oscript.reload=1;oscript.onload=oscript.onreadystatechange=function(){if((!this.readyState||this.readyState==="loaded"||this.readyState==="complete")){if(1){obj.ca_key=ca_key;obj.varCert=GetSignCert(obj.ContainerName);if(callback)callback(obj);LastCALogonType=obj.CALogonType;}}}
oscript.src=obj.CAJsPath;head.insertBefore(oscript,head.firstChild);}}
if(obj.IsSucc&&obj.ContainerName){obj.varCert=GetSignCert(obj.ContainerName);obj.ca_key=ca_key;}
return obj;}