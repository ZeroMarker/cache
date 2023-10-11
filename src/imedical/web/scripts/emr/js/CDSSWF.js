function CDSSWF(){
	this.init=function(d){
		this.CDSSUrl = d.args.CDSSUrl;
	}
	this.getData=function(text){
		if(text =="" || text == undefined || typeof text != "string") return
		var url = this.CDSSUrl + text;
		window.open(url,"CDSSWF","resizable=true,width=345,height=540,top=300,left=920");
	}
}