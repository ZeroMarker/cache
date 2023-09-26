/// date:  			2014-02-20
/// Description:  	抗菌提示功能
/// Ceator:			qp
///

function menuIn() {                         
	clearTimeout(out_ID)                       
	if( menu.pixelLeft > menuW*-1+5 ) {
		menu.pixelLeft -= 2                 
		in_ID = setTimeout("menuIn()", 0.001)   
	}
}

function menuOut() {                       
	clearTimeout(in_ID)                         
	if( menu.pixelLeft < 0) {
		menu.pixelLeft += 2                 
		out_ID = setTimeout("menuOut()", 0.001)
	}
}

function cOver() {
	clearTimeout(F_out)
	F_over = setTimeout("menuOut()", 5)
	
}

function cOut() { 
	clearTimeout(F_over)
	F_out = setTimeout("menuIn()", 5)
}

function KJTSInit() {
	menu = Cai1.style
	menuW = Cai1.offsetWidth
	Cai1.style.pixelLeft = menuW*-1+9          
	Cai1.onmouseover = cOver                  
	Cai1.onmouseout = cOut                     
	Cai1.style.visibility = "visible"
}
F_over=F_out=in_ID=out_ID=null;


function ShowKJTS(){
	var KJTSUrl="dhccpmrunqianreportgroup.csp?reportName=DHCWLKPI-KJYW-抗菌药物使用分析.rpg&ksloc="+session['LOGON.CTLOCID'];
	websys_lu(KJTSUrl,true,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530");
}

