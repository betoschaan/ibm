using UnityEngine;
using System.Collections;

public class MaterialUpdater : MonoBehaviour {

	public Material[] materials;
	public MeshRenderer[] cloths;

	public int y;

	// Use this for initialization
	void Start () {

	}

	// Update is called once per frame
	void Update () {

	}

	void OnGUI(){

		if(GUI.Button(new Rect(Screen.width - 150, Screen.height - 50, 50,25), ">>")){
			y++;
			if(y >= materials.Length)
			{
				y = 0;
			}
			for(int i = 0; i < cloths.Length; i++){
				cloths[i].material = materials[y];
			}
			
		}

		if(GUI.Button(new Rect(100, Screen.height - 50, 50,25), "<<")){
			y--;
			if(y < 0)
			{
				y = materials.Length - 1;
			}
			for(int i = 0; i < cloths.Length; i++){
				cloths[i].material = materials[y];
			}

		}
	}
}
