using UnityEngine;
//using System.Collections;

public class Rotate : MonoBehaviour
{

	public float x, y, z;

	void Update ()
	{
			this.transform.Rotate (x * Time.deltaTime, y * Time.deltaTime, z * Time.deltaTime);
	}
}
