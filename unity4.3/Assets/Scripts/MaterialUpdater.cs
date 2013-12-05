using UnityEngine;
using System.Collections;

public class MaterialUpdater : MonoBehaviour {

	public Material[] materials;
	public MeshRenderer[] cloths;

	public int y;

	public GameObject camera;

	private bool isZoom = false;

	public GameObject model;

	// Use this for initialization
	void Start () {

	}

	// Update is called once per frame
	void Update () 
	{

	}

	void OnGUI()
	{
		if(GUI.Button(new Rect(10,10, 100, 50), "Zoom"))
		{
			if(!isZoom)
			{
				camera.transform.position = new Vector3(camera.transform.position.x, camera.transform.position.y, -7.15f);
				isZoom = true;
			}
			else
			{
				camera.transform.position = new Vector3(camera.transform.position.x, camera.transform.position.y, -8f);
				isZoom = false;
			}

		}
	}

}
