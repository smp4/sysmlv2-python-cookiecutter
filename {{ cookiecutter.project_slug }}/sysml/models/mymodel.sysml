package PictureTaking {
    doc	
    /*
	 * From https://doc.mbse-syson.org/syson/v2024.9.0/user-manual/integration/interoperability.html
	 */

    part def Exposure;

	action def Focus { out xrsl: Exposure; }
	action def Shoot { in xsf: Exposure; }

	action takePicture {
		action focus: Focus[1];
		flow focus.xrsl to shoot.xsf;
		action shoot: Shoot[1];
	}
}