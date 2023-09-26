function DHCBodyLoadInitEncrypt(){
	try{
		this.myrtn="";
		DHCBodyLoadInitEncrypt.prototype.GetAllEncrypt = function(){
			for (var i=0;i<arguments.length;i++){
				var tkclassEndPiont=arguments[i].lastIndexOf(".")
				var tkclass=arguments[i].substring(0,tkclassEndPiont);
				var tkmethod=arguments[i].substring(tkclassEndPiont+1,arguments[i].length);
				this.myrtn=tkMakeServerCall(tkclass,tkmethod);
				var myrtntemp=this.myrtn.split(String.fromCharCode(2));
				for (var i=0;i<myrtntemp.length;i++){
					var arrtemp=myrtntemp[i].split(String.fromCharCode(1));
					//AddInput(arrtemp);
					eval("this."+arrtemp[0]+"=\""+arrtemp[1]+"\"");
				}
			}
		}
	}catch(E){alert(E.message);}
	
}

function AddInput(ParaArrObj){
	// ANA LOG XXX
	// this is called on Update. Will add hidden fields in OEOrder.Custom which are OEOriRowIds.
	var fObj=document.getElementById("dDHCOPAdm_Reg");
	var id=ParaArrObj[0];
	var name=ParaArrObj[1];
	var type=ParaArrObj[2];
	var value=ParaArrObj[3];
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = id;
	NewElement.name = name;
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	
	fObj.appendChild(NewElement);
  var newline= document.createElement("br");
  fObj.appendChild(newline);
	//document.fUDHCOEOrder_List_Custom.dummy.insertAdjacentElement("afterEnd",NewElement);
	//fObj.insertAdjacentElement("afterEnd",NewElement);
}

function testObj(){
	//this.obj=new Object();
	this.a="a";
	this.b="b";
	this.c="c";
	this.d="d";
	this.obj=new Object();
	this.obj.name="guorongyong"
	this.obj.value="1111"
	this.obj.OtherProtecte="OtherProtecte"
	
}
function testObj1(){
	this.a="aa";
	this.b="bb";
	this.c="cc";
	this.d="dd";
}