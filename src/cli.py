# Copyright 2023 Oreum Industries
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""CLI to manage Squirrel Radar Plots"""
import typer
from rich.progress import Progress, SpinnerColumn, TextColumn

from squirrel_radar import create_radar

__all__ = ['create']

helpd = dict(
    project_name='Project name e.g. "Company, Month Year"',
    scores='Scores must be an string of values of length 6, each score in range [0, 5], starting with Org Maturity, e.g. 123455',
)

kws_exrd = dict(exists=True, readable=True)
app = typer.Typer()


@app.command()
def create(
    project_name: str = typer.Option(None, help=helpd['project_name']),
    scores: str = typer.Option(..., help=helpd['scores']),
):
    """Create Radar Plot"""
    scoresl = [int(t) for t in str(scores)]
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        transient=True,
    ) as progress:
        t0 = progress.add_task(description="Create Radar Plot", total=1)
        create_radar(scores=scoresl, project_name=project_name)
        progress.advance(t0, advance=1)


@app.callback()
def callback():
    """Create a Squirrel Radar Plot, see https://douglassquirrel.com/radar.
    NOTE, this uses Plotly express, so needs an active internet connection.
    """
    pass


if __name__ == '__main__':
    app()
