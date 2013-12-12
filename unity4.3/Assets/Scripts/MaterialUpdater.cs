using UnityEngine;
using System.Collections;

public class MaterialUpdater : MonoBehaviour {

//	public Material[] materials;
//	public MeshRenderer[] cloths;
//
//	public int y;

	public GameObject camera;

	private bool isZoom = false;

//	public GameObject model;

	// Use this for initialization
//	void Start () {
//
//	}
//
//	// Update is called once per frame
//	void Update () 
//	{
//
//	}


//	float ROTSpeed = 5f;
//	float min = -52.0f;
//	float max = 10.0f;
//	
//	void Start()
//	{
//		min = Camera.main.fov + min;
//		max = Camera.main.fov + max;
//	}
//	
//	void Update()
//	{
//		if(Camera.main.fov <= min)
//			Camera.main.fov = min;
//		if(Camera.main.fov >= max)
//			Camera.main.fov = max;
//		
//		Camera.main.fov -= Input.GetAxis("Mouse ScrollWheel") * ROTSpeed;
//	}
//	



	

	void OnGUI()
	{
//		if(GUI.Button(new Rect(10,70, 100, 50), "Zoom"))
//		{
//			if(!isZoom)
//			{
//				camera.transform.position = new Vector3(camera.transform.position.x, camera.transform.position.y, -7.15f);
//				isZoom = true;
//			}
//			else
//			{
//				camera.transform.position = new Vector3(camera.transform.position.x, camera.transform.position.y, -8f);
//				isZoom = false;
//			}
//
//		}
		
		if(GUI.Button(new Rect(10,10, 100, 50), "Esc"))
		{
			Application.Quit();
		}
	}

}
